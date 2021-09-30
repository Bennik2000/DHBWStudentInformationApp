package de.bennik2000.dhbwstudentapp.flutter

import android.content.Context
import androidx.annotation.NonNull
import de.bennik2000.dhbwstudentapp.widget.WidgetHelper
import de.bennik2000.dhbwstudentapp.widget.today.ScheduleTodayWidget
import de.bennik2000.dhbwstudentapp.widget.now.ScheduleNowWidget
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
        when (call.method) {
            "requestWidgetRefresh" -> {
                updateWidget()
                result.success(null)
            }
            "disableWidget" -> {
                WidgetHelper(context).disableWidget()
                updateWidget()
                result.success(null)
            }
            "enableWidget" -> {
                WidgetHelper(context).enableWidget()
                updateWidget()
                result.success(null)
            }
            "areWidgetsSupported" -> {
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun updateWidget() {
        ScheduleTodayWidget.requestWidgetRefresh(context)
        ScheduleNowWidget.requestWidgetRefresh(context)
    }


}
