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
    
    func getFullDate() -> String{
        return String(date) + " " + month
    }
    
    func eventsToString(){
        print("There are: " + String(events.count) + " registered events")
        print("[")
        
        print("]")
    }
}
