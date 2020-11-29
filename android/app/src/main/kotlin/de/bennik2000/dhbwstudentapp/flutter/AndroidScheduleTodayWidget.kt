package de.bennik2000.dhbwstudentapp.flutter

import android.content.Context
import androidx.annotation.NonNull
import de.bennik2000.dhbwstudentapp.widget.ScheduleTodayWidget
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class AndroidScheduleTodayWidget(private val context: Context) : MethodChannel.MethodCallHandler {
    fun setupMethodChannel(@NonNull flutterEngine: FlutterEngine) {
        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                "de.bennik2000.dhbwstudentapp/widget")
                .setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "requestWidgetRefresh") {
            ScheduleTodayWidget.requestWidgetRefresh(context)
            result.success(null)
        } else {
            result.notImplemented()
        }
    }
}
