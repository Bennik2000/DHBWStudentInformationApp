package de.bennik2000.dhbwstudentapp

import androidx.annotation.NonNull
import de.bennik2000.dhbwstudentapp.flutter.AndroidScheduleTodayWidget
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        AndroidScheduleTodayWidget(applicationContext).setupMethodChannel(flutterEngine)
    }
}