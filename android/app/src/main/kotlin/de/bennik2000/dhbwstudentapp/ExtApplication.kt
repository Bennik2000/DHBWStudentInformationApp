package de.bennik2000.dhbwstudentapp

import android.app.Application
import io.flutter.view.FlutterMain

class ExtApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        FlutterMain.startInitialization(applicationContext)
    }
}
