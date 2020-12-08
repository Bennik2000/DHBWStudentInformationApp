package de.bennik2000.dhbwstudentapp.widget.now

import android.content.Intent
import android.widget.RemoteViewsService

class NowScheduleEntryRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        return NowScheduleEntryViewsFactory(applicationContext)
    }
}