package de.bennik2000.dhbwstudentapp

import android.app.Application
import com.jakewharton.threetenabp.AndroidThreeTen
import de.bennik2000.dhbwstudentapp.database.ScheduleProvider
import io.flutter.view.FlutterMain
import org.threeten.bp.LocalDate

class ExtApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        AndroidThreeTen.init(this)
        FlutterMain.startInitialization(applicationContext)

        ScheduleProvider(applicationContext).queryScheduleEntriesForDay(LocalDate.of(2020, 11, 18))
    }
}
