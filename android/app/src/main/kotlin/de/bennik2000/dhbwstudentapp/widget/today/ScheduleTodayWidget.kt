package de.bennik2000.dhbwstudentapp.widget.today

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
import de.bennik2000.dhbwstudentapp.widget.WidgetHelper
import org.threeten.bp.LocalDate

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

        if(WidgetHelper(context).isWidgetEnabled()) {
            views.setViewVisibility(R.id.layout_purchase, View.INVISIBLE)

            val hasEntries = ScheduleProvider(context).hasScheduleEntriesForDay(LocalDate.now())

            updateScheduleEntryList(context, views, appWidgetManager, appWidgetId)
            updateScheduleListEmptyState(views, hasEntries)
        }
        else {
            views.setViewVisibility(R.id.layout_empty_state, View.INVISIBLE)
            views.setViewVisibility(R.id.schedule_entries_list_view, View.INVISIBLE)
            views.setViewVisibility(R.id.layout_purchase, View.VISIBLE)
        }


        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun updateScheduleEntryList(context: Context, views: RemoteViews, appWidgetManager: AppWidgetManager, id: Int) {
        val intent = Intent(context, TodayScheduleEntryRemoteViewsService::class.java)
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
