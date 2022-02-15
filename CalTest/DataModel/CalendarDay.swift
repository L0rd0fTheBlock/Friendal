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
    var date: Date
    var hasEvents: Bool
    var isToday = false
    
    
    
    init(forDate: Date = Date()) {
        date = forDate
        hasEvents = false
        events = [Event]()
        setIsToday()
    }
    
    init() {
        date = Date()
        hasEvents = false
        events = [Event]()
        setIsToday()
    }
    
    func getDay() -> String{
        
        let calendar = Calendar.current
        
        let dateString = "\(calendar.component(.day, from: date))"
        
        return dateString
    }
    
    func getMonth() -> String{
        
        let calendar = Calendar.current
        
        let dateString = "\(calendar.component(.month, from: date))"
        
        return dateString
    }
    
    func getMonthasInt() -> Int{
        
        let calendar = Calendar.current
        
        let dateString = calendar.component(.month, from: date)
        
        return dateString
    }
    
    func getYear() -> String{
        
        let calendar = Calendar.current
        
        let dateString = "\(calendar.component(.year, from: date))"
        
        return dateString
    }
    
    
    func getFullDate() -> String{
        
        let calendar = Calendar.current
        
        return "\(calendar.component(.day, from: date))/\(calendar.component(.month, from: date))/\(calendar.component(.year, from: date))"
    }
    
    func getDateAsDate() -> Date{
        
        return date
    }
    
    func doesHaveEvents() -> Bool{
        if(events.count > 0){
            return true
        }else{
            return false
        }
    }
    
    func setIsToday(){
        let date = Date()
        let calendar = Calendar.current

        let todaysDate = "\(calendar.component(.day, from: date))/\(calendar.component(.month, from: date))/\(calendar.component(.year, from: date))"
        
        /*
        if(String(month) == String(calendar.component(.month, from: date))){
            if(getDate() == String(calendar.component(.day, from: date))){
                if(String(year) == String(calendar.component(.year, from: date))){
                    isToday = true
                }
            }
        }*/
        
        if(todaysDate == getDay()){
            isToday = true
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
                events.remove(at: index)
            }
        }
        
    }
    
    func monthAsString() ->String{
        
        
        
        switch(getMonthasInt()){
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
    
    
}
