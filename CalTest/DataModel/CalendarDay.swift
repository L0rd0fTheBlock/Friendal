//
//  Day.swift
//  CalTest
//
//  Created by Jamie McAllister on 20/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation
class CalendarDay{
    var events:[Event]
    var date: String
    var month: String
    let hasEvents: Bool
    
    
    
    init(onDay: String, ofMonth: String = "NONE", hasEvent: Bool) {
        date = onDay
        month = ofMonth
        hasEvents = hasEvent
        events = [Event]()
    }
    
    func getDate() -> String{
        return date
    }
    
    func doesHaveEvents() -> Bool{
        return hasEvents
    }
    func countEvents() -> Int{
        return events.count
    }
    func addEvent(event: Event){
        events.append(event)
    }
    
    func cancelEvent(_ id: String){
        
        for (index, event) in events.enumerated(){
            if(event.id == id){
                events.remove(at: index)
            }
        }
        
    }
    
    func monthAsInt() ->Int{
        
        switch(month){
        case "Jan":
            return 1
        case "Feb":
            return 2
        case "Mar":
            return 3
        case "Apr":
            return 4
        case "May":
            return 5
        case "Jun":
            return 6
        case "Jul":
            return 7
        case "Aug":
            return 8
        case "Sep":
            return 9
        case "Oct":
            return 10
        case "Nov":
            return 11
        default:
            return 12
        }
    }
    
    func getFullDate() -> String{
        return String(date) + " " + month
    }
    
    func getDateAsDate() -> Date{
        
        var dateComponents = DateComponents()
        
        dateComponents.month = Int(monthAsInt())
        dateComponents.day = Int(date)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        dateComponents.year = Int(formatter.string(from: Date()))
        
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents)
        return someDateTime!
    }
    
    func eventsToString(){
        print("There are: " + String(events.count) + " registered events")
        print("[")
        
        print("]")
    }
}
