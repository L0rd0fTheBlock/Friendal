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
    var date: Int
    var month: Int
    var year: Int
    var hasEvents: Bool
    
    
    
    init(onDay: Int, ofMonth: Int = 0, ofYear: Int = 0) {
        date = onDay
        month = ofMonth
        year = ofYear
        hasEvents = false
        events = [Event]()
    }
    
    init() {
        date = 0
        month = 0
        year = 0
        hasEvents = false
        events = [Event]()
    }
    
    func getDate() -> String{
        return String(date)
    }
    
    func doesHaveEvents() -> Bool{
        if(events.count > 0){
            return true
        }else{
            return false
        }
    }
    func countEvents() -> Int{
        return events.count
    }
    func addEvent(event: Event){
        events.append(event)
        hasEvents = true
    }
    
    func update(completion: @escaping (NSError?) ->()){
       // let ch = CalendarHandler()
       /* ch.getCalendarDay(self, forUser: Settings.sharedInstance.me.uid, onDay: date, ofMonth: String(monthAsInt()), forYear: year, completion: { (error) in
            completion(error)
        })*/
    }
    
    func cancelEvent(_ id: String){
        
        for (index, event) in events.enumerated(){
            if(event.id == id){
                print("Removing event from index: ", index)
                print(events.count)
                events.remove(at: index)
            }
        }
        
    }
    
    func monthAsString() ->String{
        
        switch(month){
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        default:
            return "Dec"
        }
    }
    
    func getFullDate() -> String{
        return String(date) + " " + monthAsString()
    }
    
    func getDateAsDate() -> Date{
        
        var dateComponents = DateComponents()
        
        dateComponents.month = month
        dateComponents.day = date
        
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
