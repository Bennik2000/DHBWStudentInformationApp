package de.bennik2000.dhbwstudentapp.database

import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import de.bennik2000.dhbwstudentapp.model.ScheduleEntry
import io.flutter.util.PathUtils
import org.threeten.bp.*
import java.io.File
import java.lang.Exception
import java.nio.file.Path


class ScheduleProvider(private val context: Context) {

    private val zoneOffset = OffsetDateTime.now().offset


    fun hasScheduleEntriesForDay(date: LocalDate): Boolean {
        openDatabase()?.use { database ->
            val startMillis = date.atStartOfDay().toEpochSecond(zoneOffset) * 1000
            val endMillis = date.plusDays(1).atStartOfDay().toEpochSecond(zoneOffset) * 1000

            database.query(
                    "ScheduleEntries",
                    arrayOf("id"), "start>=? AND end <=?",
                    arrayOf(startMillis.toString(), endMillis.toString()),
                    "",
                    "",
                    "start ASC").use { result ->
                return result.count > 0
            }
        }

        return false
    }

    fun queryScheduleEntriesForDay(date: LocalDate): ArrayList<ScheduleEntry> {
        openDatabase()?.use { database ->
            val startMillis = date.atStartOfDay().toEpochSecond(zoneOffset) * 1000
            val endMillis = date.plusDays(1).atStartOfDay().toEpochSecond(zoneOffset) * 1000

            database.query(
                    "ScheduleEntries",
                    arrayOf("id", "start", "end", "details", "professor", "room", "title", "type"), "start>=? AND end <=?",
                    arrayOf(startMillis.toString(), endMillis.toString()),
                    "",
                    "",
                    "start ASC").use { result ->
                return readScheduleEntries(result)
            }
        }

        return ArrayList()
    }

    private fun openDatabase(): SQLiteDatabase? {
        val path = PathUtils.getDataDirectory(context) + "/Database.db"

        if(!File(path).exists()) {
            return null
        }

        return try{
            SQLiteDatabase
                    .openDatabase(path,
                            null,
                            0)
        }
        catch (e: Exception) {
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
}