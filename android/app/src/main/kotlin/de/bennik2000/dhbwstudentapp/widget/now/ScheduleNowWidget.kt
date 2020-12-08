package de.bennik2000.dhbwstudentapp.widget.now

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import de.bennik2000.dhbwstudentapp.AlarmManagerUtils
import de.bennik2000.dhbwstudentapp.R
import de.bennik2000.dhbwstudentapp.database.ScheduleProvider
import de.bennik2000.dhbwstudentapp.model.ScheduleEntry
import org.threeten.bp.LocalDate
import org.threeten.bp.LocalDateTime

/**
 * Implementation of App Widget functionality.
 */
class ScheduleNowWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        val pendingEntries = ScheduleProvider(context).queryPendingForDay(LocalDateTime.now())

        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId, pendingEntries)
        }

        scheduleWidgetUpdate(context, pendingEntries)
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        cancelWidgetUpdate(context)
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int, pendingEntries: List<ScheduleEntry>) {
        Log.d("ScheduleNowWidget", "Updating widget with id $appWidgetId")

        val views = RemoteViews(context.packageName, R.layout.widget_schedule_now)

        updateScheduleEntryList(context, views, appWidgetManager, appWidgetId)
        updateScheduleListEmptyState(views, pendingEntries.isNotEmpty())

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun updateScheduleEntryList(context: Context, views: RemoteViews, appWidgetManager: AppWidgetManager, id: Int) {
        val intent = Intent(context, NowScheduleEntryRemoteViewsService::class.java)
        views.setRemoteAdapter(R.id.schedule_entries_list_view, intent)

        appWidgetManager.notifyAppWidgetViewDataChanged(id, R.id.schedule_entries_list_view)
    }

    private fun updateScheduleListEmptyState(views: RemoteViews, hasEntries: Boolean) {
        var visibility = View.VISIBLE

        if (hasEntries) {
            visibility = View.INVISIBLE
        }

        views.setViewVisibility(R.id.layout_empty_state, visibility)
    }


    companion object {
        fun requestWidgetRefresh(context: Context) {
            val intent = getWidgetUpdateIntent(context)
            context.sendBroadcast(intent)
        }

        private fun getWidgetUpdateIntent(context: Context): Intent {
            val intent = Intent(context, ScheduleNowWidget::class.java)

            intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE

            val ids: IntArray = AppWidgetManager
                    .getInstance(context.applicationContext)
                    .getAppWidgetIds(ComponentName(context, ScheduleNowWidget::class.java))

            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)

            return intent
        }

        private fun scheduleWidgetUpdate(context: Context, entries: List<ScheduleEntry>) {
            val now = LocalDateTime.now()

            var updateAt = LocalDate
                    .now()
                    .plusDays(1)
                    .atStartOfDay()

            for (entry in entries) {
                if (entry.start.isAfter(now)) {
                    updateAt = entry.start
                    break
                }
                if (entry.end.isAfter(now)) {
                    updateAt = entry.end
                    break
                }
            }
            
            updateAt.plusSeconds(1)

            Log.d("ScheduleNowWidget", "Scheduling widget update at $updateAt")

            val intent = getWidgetUpdateIntent(context)
            AlarmManagerUtils.scheduleIntentAtExactTime(context, intent, updateAt)
        }

        private fun cancelWidgetUpdate(context: Context) {
            val intent = getWidgetUpdateIntent(context)
            AlarmManagerUtils.cancelIntent(context, intent)
        }
    }
}
