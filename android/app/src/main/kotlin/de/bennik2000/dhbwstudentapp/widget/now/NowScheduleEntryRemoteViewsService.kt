package de.bennik2000.dhbwstudentapp.widget.now

import android.content.Intent
import android.util.Log
import android.widget.RemoteViewsService
import de.bennik2000.dhbwstudentapp.widget.ScheduleEntryViewsFactory

class NowScheduleEntryRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        return NowScheduleEntryViewsFactory(applicationContext)
    }
}