package de.bennik2000.dhbwstudentapp

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import org.threeten.bp.LocalDateTime
import org.threeten.bp.OffsetDateTime

class AlarmManagerUtils {
    companion object {
        fun scheduleIntentAtExactTime(context: Context, intent: Intent, scheduleAt: LocalDateTime) {
            val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, 0)
            
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

            val zoneOffset = OffsetDateTime.now().offset
            val updateAtMillis = scheduleAt.toEpochSecond(zoneOffset) * 1000

            alarmManager.cancel(pendingIntent)

            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> {
                    alarmManager
                            .setExactAndAllowWhileIdle(
                                    AlarmManager.RTC_WAKEUP,
                                    updateAtMillis,
                                    pendingIntent)
                }
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT -> {
                    alarmManager
                            .setExact(AlarmManager.RTC_WAKEUP,
                                    updateAtMillis,
                                    pendingIntent)
                }
                else -> {
                    alarmManager
                            .set(AlarmManager.RTC_WAKEUP,
                                    updateAtMillis,
                                    pendingIntent)
                }
            }
        }
        
        fun cancelIntent(context: Context, intent: Intent) {
            val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, 0)
            
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarmManager.cancel(pendingIntent)
        }
    }
}