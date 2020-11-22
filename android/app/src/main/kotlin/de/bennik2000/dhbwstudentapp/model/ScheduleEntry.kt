package de.bennik2000.dhbwstudentapp.model

import org.threeten.bp.LocalDateTime

class ScheduleEntry(
        val id: Int,
        val title: String,
        val details: String,
        val professor: String,
        val room: String,
        val type: Int,
        val start: LocalDateTime,
        val end: LocalDateTime)
