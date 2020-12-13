package de.bennik2000.dhbwstudentapp.widget

import android.content.Context

class WidgetHelper(private val context: Context) {
    fun isWidgetEnabled(): Boolean {
        val preferences = context.getSharedPreferences(
                "${context.packageName}.widget_preferences",
                Context.MODE_PRIVATE)

        return preferences.getBoolean("isWidgetEnabled", false)
    }

    fun enableWidget() {
        setWidgetEnabled(true)
    }

    fun disableWidget() {
        setWidgetEnabled(false)
    }

    private fun setWidgetEnabled(isEnabled: Boolean) {
        val preferences = context.getSharedPreferences(
                "${context.packageName}.widget_preferences",
                Context.MODE_PRIVATE)

        preferences.edit().putBoolean("isWidgetEnabled", isEnabled).apply()
    }
}
