package de.bennik2000.dhbwstudentapp.database

import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import de.bennik2000.dhbwstudentapp.model.ScheduleEntry
import io.flutter.util.PathUtils
import org.threeten.bp.LocalDate
import org.threeten.bp.LocalDateTime
import org.threeten.bp.OffsetDateTime
import java.io.File


class ScheduleProvider(private val context: Context) {

    private val zoneOffset = OffsetDateTime.now().offset

    
    fun hasScheduleEntriesForDay(date: LocalDate): Boolean {
        val start = date.atStartOfDay()
        val end = date.plusDays(1).atStartOfDay()
        
        return hasScheduleEntriesBetween(start, end)
    }

    fun hasScheduleEntriesBetween(start: LocalDateTime, end: LocalDateTime): Boolean {
        try {
            openDatabase()?.use { database ->
                val startMillis = start.toEpochSecond(zoneOffset) * 1000
                val endMillis = end.toEpochSecond(zoneOffset) * 1000

                database.rawQuery(
                        SCHEDULE_ENTRIES_BETWEEN_SQL,
                        arrayOf(startMillis.toString(), endMillis.toString())).use { result ->
                    return result.count > 0
                }
            }
        } catch (ex: Exception) {
        }
        return false
    }

    fun queryScheduleEntriesForDay(date: LocalDate): ArrayList<ScheduleEntry> {
        try {
            openDatabase()?.use { database ->
                val startMillis = date.atStartOfDay().toEpochSecond(zoneOffset) * 1000
                val endMillis = date.plusDays(1).atStartOfDay().toEpochSecond(zoneOffset) * 1000

                database.rawQuery(
                        SCHEDULE_ENTRIES_BETWEEN_SQL,
                        arrayOf(startMillis.toString(), endMillis.toString())).use { result ->
                    return readScheduleEntries(result)
                }
            }
        }
        catch(ex: Exception) {
        }
        return ArrayList()
    }

    fun queryPendingForDay(now: LocalDateTime): List<ScheduleEntry> {
        val midnight = LocalDate
                .now()
                .plusDays(1)
                .atStartOfDay()

        return ScheduleProvider(context)
                .queryScheduleEntriesBetween(now, midnight)
    }
    
    fun queryScheduleEntriesBetween(start: LocalDateTime, end: LocalDateTime): ArrayList<ScheduleEntry> {
        try {
            openDatabase()?.use { database ->
                val startMillis = start.toEpochSecond(zoneOffset) * 1000
                val endMillis = end.toEpochSecond(zoneOffset) * 1000

                database.rawQuery(
                        SCHEDULE_ENTRIES_BETWEEN_SQL,
                        arrayOf(startMillis.toString(), endMillis.toString())).use { result ->
                    return readScheduleEntries(result)
                }
            }
        }
        catch (ex: Exception) {
        }
        return ArrayList()
    }

    private fun openDatabase(): SQLiteDatabase? {
        val path = PathUtils.getDataDirectory(context) + "/Database.db"

        if (!File(path).exists()) {
            return null
        }

        return try {
            SQLiteDatabase
                    .openDatabase(path,
                            null,
                            0)
        } catch (e: Exception) {
            null
        }
    }

    private fun readScheduleEntries(result: Cursor): ArrayList<ScheduleEntry> {
        val entries: ArrayList<ScheduleEntry> = ArrayList()

        while (result.moveToNext()) {
            val entry = readScheduleEntry(result)
            entries.add(entry)
        }

        return entries
    }

    private fun readScheduleEntry(result: Cursor): ScheduleEntry {
        val startMillis = result.getLong(result.getColumnIndex("start"))
        val endMillis = result.getLong(result.getColumnIndex("end"))

        val start = LocalDateTime.ofEpochSecond(
                startMillis / 1000,
                0,
                zoneOffset)

        val end = LocalDateTime.ofEpochSecond(
                endMillis / 1000,
                0,
                zoneOffset)

        return ScheduleEntry(
                result.getInt(result.getColumnIndex("id")),
                result.getString(result.getColumnIndex("title")),
                result.getString(result.getColumnIndex("details")),
                result.getString(result.getColumnIndex("professor")),
                result.getString(result.getColumnIndex("room")),
                result.getInt(result.getColumnIndex("type")),
                start,
                end)
    }

    companion object {
        private const val SCHEDULE_ENTRIES_BETWEEN_SQL =
                "SELECT  \n" +
                "ScheduleEntries.id,\n" +
                "ScheduleEntries.start,\n" +
                "ScheduleEntries.end,\n" +
                "ScheduleEntries.title,\n" +
                "ScheduleEntries.details,\n" +
                "ScheduleEntries.professor,\n" +
                "ScheduleEntries.room,\n" +
                "ScheduleEntries.type\n" +
                "FROM \n" +
                "    ScheduleEntries\n" +
                "    LEFT JOIN ScheduleEntryFilters\n" +
                "        ON ScheduleEntries.title = ScheduleEntryFilters.title\n" +
                "    WHERE end >= ? AND start <= ?\n" +
                "        AND ScheduleEntryFilters.title IS NULL\n" +
                "ORDER BY ScheduleEntries.start ASC;\n"
    }
}
