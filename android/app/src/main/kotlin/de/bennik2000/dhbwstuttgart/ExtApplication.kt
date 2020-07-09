package de.bennik2000.dhbwstuttgart

import android.app.Application
import io.flutter.view.FlutterMain

class ExtApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        FlutterMain.startInitialization(applicationContext)
    }
}
