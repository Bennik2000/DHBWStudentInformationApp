package de.bennik2000.dhbwstudentapp.widget

import android.content.Intent
import android.util.Log
import android.widget.RemoteViewsService

class TodayScheduleEntryRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        Log.d("ScheduleEntryRemoteView", "Creating ScheduleEntryViewsFactory")
        return ScheduleEntryViewsFactory(applicationContext)
    }
}