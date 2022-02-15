//
//  CalendarHandler.swift
//  CalTest
//
//  Created by Andrew McAllister on 19/11/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd. All rights reserved.
//

import Foundation
//import FacebookCore
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class CalendarHandler: Handler{
    
    var cal: CalendarViewController? = nil
    var month = [CalendarDay]()
    //MARK: Initialisers
    init(_ calendar:CalendarViewController){
        super.init()
        cal = calendar
    }
    
    override init(){
        super.init()
    }
    
    //MARK: Calendar Month Day and Events
    func getMonth(forMonth: Int, ofYear: Int, withUser: String, completion:([CalendarDay]) -> Void){
        var dateComponents = DateComponents()
        dateComponents.year = ofYear
        dateComponents.month = forMonth
        dateComponents.day = 1
        
        let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
        let date = userCalendar.date(from: dateComponents) //create a Date() object from the date components of the 1st of the chosen month and year
        var weekday = userCalendar.component(.weekday, from: date!) as Int
        
        var length = 0
        let thisMonth = userCalendar.component(.month, from: date!)
        let thisYear = userCalendar.component(.year, from: date!)
        var tDay = 1

        if(thisMonth == 2){
            if(thisYear % 2 == 0){
                length = 29
            }
            else{
                length = 28
            }
        }else{
            if(thisMonth % 2 == 0){
                length = 30
            }else{
                length = 31
            }
        }
        /*
         date:          Array
         
         Monday: 1      0
         Tuesday: 2     1
         Wed: 3         2
         Thur: 4        3
         Fri: 5         4
         Sat: 6         5
         sun: 7         6
         
         */

        weekday -= 1//shift day of the week backwards - sunday becomes 0, Monday 1 etc
        //REMEMBER: Sunday is day 0
        if(weekday>0){
            while month.count < weekday-1{
                month.append(CalendarDay())
            }
        }
        else{
            //weekday is less than 1 so MUST be sunday
            //need 6 empty days
            var day = 1
            while day < 7 {
                month.append(CalendarDay())
                day += 1
            }
        }


        while tDay<length+1{
            
            dateComponents.day = tDay
            
            let thisDay = userCalendar.date(from: dateComponents)!
            
            let day = CalendarDay(forDate: thisDay)
            month.append(day)
            tDay += 1
        }
        completion(month)
        
    }
    
    fileprivate func getUserEvents(_ fromUser: String, _ forDate: Date, _ completion: @escaping ([Event]) -> Void) {
        var events = [Event]()
        
        var todayComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: forDate)
        
        todayComponents.setValue(00, for: .hour)
        todayComponents.setValue(00, for: .minute)
        todayComponents.setValue(01, for: .second)
        
        let today = Calendar.current.date(from: todayComponents)
        
        
        //print(Calendar.current.date(from: todayComponents))
        
        var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today!)!
        
        
        
        /*
         
         for each day named "today"
            get all the events that start and end today
            if the event "bridgesDays" (that's a property of Event on the app)
               store the event in a "bridgingEvents" property
             otherwise {Do normal event stuff}
         After the loop

         run the loop again
            for each bridgingEvent named "bridgedEvent"
               if today is between bridgedEvent's start and end date
                  add a copy of the BridgedEvent to today's Events
         
         */
        
        db.collection("Event").whereField("user", isEqualTo: fromUser)
            .whereField("start", isGreaterThanOrEqualTo: today)
            .whereField("start", isLessThan: tomorrow).getDocuments { shapshotS, err in
                
                //print("start events: \(String(describing: shapshotS?.count))")
                
                self.db.collection("Event").whereField("end", isGreaterThanOrEqualTo: today)
                    .whereField("end", isLessThan: tomorrow).getDocuments { snapshotE, err in
                        
                   // print("end Events: \(String(describing: snapshotE?.count))")
                    if let err = err {
                     //   print("Error getting documents: \(err)")
                    } else {
                        for document in shapshotS!.documents {
                            let event = Event(document: document)
                            events.append(event)
                        }
                        for document in snapshotE!.documents {
                            let event = Event(document: document)
                            if(event.start != forDate){
                                events.append(event)
                            }
                        }
                    }
                    completion(events)
                }
            }
    }
    
    func getEvents(forDate: Date, fromUser: String, completion: @escaping([Event]) -> Void){
       var events = [Event]()
       // print("fordate: \(forDate)")
            getUserEvents(fromUser, forDate, {(userEvents) in
                events.append(contentsOf: userEvents)
                /*inviteHandler.getRequestEvents(forUser: fromUser, onDate: forDate) { invites in
                    events.append(contentsOf: invites)
                    completion(events)
                }*/
                completion(events)
                #warning("Re-implement Invited User Events")
            })
    }
    
    func getEvent(withId: String, completion: @escaping(Event) -> Void){
        
        db.collection("Event").document(withId).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let event = Event(document: document!)
                completion(event)
            }
                
        }
                
    }
    
    
    func addEvent(event: Event){
        var ref: DocumentReference? = nil
        ref = db.collection("Event").addDocument(data: event.toArray())
            { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
    }
    
    func addEvent(event: Event, completion: @escaping (String) -> Void){
        var ref: DocumentReference? = nil
        ref = db.collection("Event").addDocument(data: event.toArray())
            { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        completion("Error")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        completion(ref!.documentID)
                    }
                }
    }
    
    func update(event: Event, withId: String){
        db.collection("Event").document(withId).setData(event.toArray()){err in
            
            
        }
        
    }
    //MARK: Message
    
    func sendMessage(to: String, type: Int, withRef: String){
        
        //let message = ["user": to, "type": type, "read": false, "sender": Auth.auth().currentUser?.uid] as [String : Any]
        
        //db.collection("Message").addDocument(data: message)
        
    }
    
    func getMessages(){
        /*
         1: Request Recieved
         2: Request Responded
         3: Event Calncelled
         4: Event Moved
         */
        
    }
    
  
    func getError(from: NSError) ->NSError{
        print("===GETERROR===")
        if(from.domain == "NSCocoaErrorDomain"){
            return NSError(domain: "com.makeitfortheweb.palendar", code: 101, userInfo: ["message": "An error occured while accessing the calendar."])
        }else if(from.domain == NSURLErrorDomain && from.code == -1009){
            return NSError(domain: "com.makeitfortheweb.palendar", code: 100, userInfo: ["message": "The Internet connection appears to be offline."])
        }else{
            return NSError(domain: "com.makeitfortheweb.palendar", code: 001, userInfo: ["message": "An unknown error has occured while making your request."])
        }
    }

    
    //MARK: Helper Functions
    
    func sortByIdReverse(_ statuses: [Status]) -> [Status]{
        
        var stats = statuses
        var shifted = true
        
        repeat {
            shifted = false
            for (index, status) in stats.enumerated(){
                let stat = status
                if(stat.isAd != nil){
                   
                }else{
                    stat.isAd = false
                }
                if(index == 0){
                }else{
                    if(status.id! > stats[index - 1].id!){
                        let taken = stats[index - 1]
                        stats[index - 1] = stat
                        stats[index] = taken
                        shifted = true
                    }
                }
            }
        } while (shifted);
        
        return stats
        
    }
    
    func propogateAds(_ statuses: [Status]) -> [Status]{
        
        var stat = statuses
        
        
        if(stat.count > 0){
           
            var index = 1
            repeat{
                
                if(index < 1){
                    
                }else{
                    let chance = arc4random()%10
                    
                   
                    
                    if(chance < 3 && !stat[index - 1].isAd!){
                      
                        let statAd = Status(isAd: true)
                        
                        stat.insert(statAd, at: index)
                        
                    }
                }
                index = index + 1
            }while(index <= stat.count)
        }else{
            let statAd = Status(isAd: true)
            
            stat.insert(statAd, at: 0)
        }
        return stat
    }
    
    func prefixedIntegerString(_ num: Int)-> String{
        
        if(num < 10){
            return "0\(num)"
            
        }else{
            return String(num)
        }
        
        
    }
    
}//end class
