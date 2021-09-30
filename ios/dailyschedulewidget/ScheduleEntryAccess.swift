//
//  scheduleEntryAccess.swift
//  Runner
//
//  Created by xamarin build on 04.12.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import SQLite3

public class ScheduleEntryAccess {
    var db:OpaquePointer?
    
    init()
    {
        db = openDatabase()
    }
    
    public func openDatabase() -> OpaquePointer? {
        let documentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.de.bennik2000.dhbwstudentapp")!
        
        let databasePath = documentsDirectory.appendingPathComponent("Database.db")
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(databasePath.path, &db) != SQLITE_OK
        {
            print("Failed to open database!")
            return nil
        }
        else
        {
            return db
        }
    }
    
    func queryScheduleEntriesBetween(dateStart: Date, dateEnd: Date) -> [ScheduleEntry] {
        let startMillis: Double = dateStart.timeIntervalSince1970 * 1000
        let endMillis: Double = dateEnd.timeIntervalSince1970 * 1000
        
        let query = "SELECT  \n" +
                    "ScheduleEntries.id,\n" +
                    "ScheduleEntries.start,\n" +
                    "ScheduleEntries.end,\n" +
                    "ScheduleEntries.title,\n" +
                    "ScheduleEntries.details,\n" +
                    "ScheduleEntries.professor,\n" +
                    "ScheduleEntries.room,\n" +
                    "ScheduleEntries.type\n" +
                    "FROM \n" +
                    "    ScheduleEntries\n" +
                    "    LEFT JOIN ScheduleEntryFilters\n" +
                    "        ON ScheduleEntries.title = ScheduleEntryFilters.title\n" +
                    "    WHERE end >= \(startMillis) AND start <= \(endMillis)\n" +
                    "        AND ScheduleEntryFilters.title IS NULL\n" +
                    "ORDER BY ScheduleEntries.start ASC;\n";
        
        var cursor: OpaquePointer? = nil
        var scheduleEntries : [ScheduleEntry] = []
        
        if sqlite3_prepare_v2(db, query, -1, &cursor, nil) == SQLITE_OK {
            while sqlite3_step(cursor) == SQLITE_ROW {
                scheduleEntries.append(getScheduleEntryFromPointer(pointer: cursor))
            }
        }
        
        sqlite3_finalize(cursor)
        return scheduleEntries
    }
    
    private func getScheduleEntryFromPointer(pointer: OpaquePointer!) -> ScheduleEntry {
        let id = sqlite3_column_int(pointer, 0)
        let start = sqlite3_column_int64(pointer, 1)
        let end = sqlite3_column_int64(pointer, 2)
        let details = getColumnString(pointer: pointer, column: 3)
        let professor = getColumnString(pointer: pointer, column: 4)
        let room = getColumnString(pointer: pointer, column: 5)
        let title = getColumnString(pointer: pointer, column: 6)
        let type = sqlite3_column_int(pointer, 7)
        
        let startDate = Date(timeIntervalSince1970: TimeInterval(start / 1000))
        let endDate = Date(timeIntervalSince1970: TimeInterval(end / 1000))
        
        return ScheduleEntry(
            id: Int(id),
            start: startDate,
            end: endDate,
            details: details,
            professor: professor,
            room: room,
            title: title,
            type: Int(type)
        )
    }
    
    private func getColumnString(pointer: OpaquePointer!, column: Int32) -> String {
        return String(describing: String(cString: sqlite3_column_text(pointer, column)))
    }
}
