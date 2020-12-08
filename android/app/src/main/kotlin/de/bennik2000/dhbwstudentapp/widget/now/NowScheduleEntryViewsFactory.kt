package de.bennik2000.dhbwstudentapp.widget.now

import android.content.Context
import android.widget.AdapterView
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import de.bennik2000.dhbwstudentapp.R
import de.bennik2000.dhbwstudentapp.database.ScheduleProvider
import de.bennik2000.dhbwstudentapp.model.ScheduleEntry
import org.threeten.bp.LocalDate
import org.threeten.bp.LocalDateTime
import org.threeten.bp.OffsetDateTime
import org.threeten.bp.format.DateTimeFormatter


class NowScheduleEntryViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {

    private var entries: ArrayList<ScheduleEntry> = ArrayList()
    private val formatter = DateTimeFormatter.ofPattern("HH:mm")


    override fun onCreate() {
        loadScheduleForToday()
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getItemId(position: Int): Long {
        return entries[position].id.toLong()
    }

    override fun onDataSetChanged() {
        loadScheduleForToday()
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    override fun getViewAt(position: Int): RemoteViews? {
        if (position == AdapterView.INVALID_POSITION || position >= entries.size) {
            return null
        }

        val rv = RemoteViews(context.packageName, R.layout.widget_schedule_entry_list_item1)

        val entry = entries[position]

        rv.setTextViewText(R.id.text_view_entry_title, entry.title)
        rv.setTextViewText(R.id.text_view_time_start, entry.start.format(formatter))
        rv.setTextViewText(R.id.text_view_time_end, entry.end.format(formatter))
        rv.setTextViewText(R.id.text_view_entry_room, entry.room)

        val background = arrayOf(
                R.drawable.schedule_now_entry_unknown_background,
                R.drawable.schedule_now_entry_class_background,
                R.drawable.schedule_now_entry_online_background,
                R.drawable.schedule_now_entry_holiday_background,
                R.drawable.schedule_now_entry_exam_background
        )

        if (entry.type >= 0 && entry.type < background.size) {
            rv.setInt(R.id.layout_schedule_entry, "setBackgroundResource", background[entry.type])
        }

        return rv
    }

    override fun getCount(): Int {
        return entries.size
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun onDestroy() {
    }

    private fun loadScheduleForToday() {
        val midnight = LocalDate
                .now()
                .plusDays(1)
                .atStartOfDay()

        entries = ScheduleProvider(context)
                .queryScheduleEntriesBetween(LocalDateTime.now(), midnight)
        // TODO: Schedule update
    }
}
