package de.bennik2000.dhbwstudentapp.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import de.bennik2000.dhbwstudentapp.MainActivity
import de.bennik2000.dhbwstudentapp.R
import de.bennik2000.dhbwstudentapp.database.ScheduleProvider
import org.threeten.bp.LocalDate
import java.util.*

class ScheduleTodayWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        Log.d("ScheduleTodayWidget", "Updating widget with id $appWidgetId")

        val views = RemoteViews(context.packageName, R.layout.widget_schedule_today)

        val pendingIntent = PendingIntent.getActivity(context,
                0,
                Intent(context, MainActivity::class.java),
                0)
        views.setOnClickPendingIntent(R.id.widget_title, pendingIntent)

        val hasEntries = ScheduleProvider(context).hasScheduleEntriesForDay(LocalDate.now())

        if (hasEntries) {
            updateScheduleEntryList(context, views)
        }

        updateScheduleListEmptyState(context, views, hasEntries)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun updateScheduleEntryList(context: Context, views: RemoteViews) {
        val intent = Intent(context, ScheduleEntryRemoteViewsService::class.java)
        views.setRemoteAdapter(R.id.schedule_entries_list_view, intent)
    }

    private fun updateScheduleListEmptyState(context: Context, views: RemoteViews, hasEntries: Boolean) {
        var visibility = View.VISIBLE

        if (hasEntries) {
            visibility = View.INVISIBLE
        }

        views.setViewVisibility(R.id.layout_empty_state, visibility)
    }


    companion object {
        fun requestWidgetRefresh(context: Context) {
            val intent = Intent(context, ScheduleTodayWidget::class.java)

            intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE

            val ids: IntArray = AppWidgetManager
                    .getInstance(context.applicationContext)
                    .getAppWidgetIds(ComponentName(context, ScheduleTodayWidget::class.java))

            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
            context.sendBroadcast(intent)
        }
    }
}
