package de.bennik2000.dhbwstudentapp.widget.today

import android.content.Intent
import android.util.Log
import android.widget.RemoteViewsService
import de.bennik2000.dhbwstudentapp.widget.today.ScheduleEntryViewsFactory

class TodayScheduleEntryRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        Log.d("ScheduleEntryRemoteView", "Creating ScheduleEntryViewsFactory")
        return ScheduleEntryViewsFactory(applicationContext)
    }
}