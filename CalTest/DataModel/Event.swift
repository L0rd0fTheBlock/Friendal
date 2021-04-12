//
//  Event.swift
//  CalTest
//
//  Created by Jamie McAllister on 20/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation

class Event{
    let id: String
    var title: String?
    var date: String?
    var month: String?
    var year: String?
    var start: String?
    var end: String?
    var creator: String?
    var notes: String? = nil
    var count: String = "0"
    var invitees:[String] = []
    var location: String? = nil
    var canInvite: Bool = false
    var isPrivate: Bool = false//false = visible, true = "busy"
    var isUserInvited: Bool = false
    var isAllDay: Bool = true
    
    init(){
        id = "0"
    }
    
    init(_ id: String, title: String, date: String, month: String, year: String, start: String, end: String, count: String, creator: String, privacy: String, allDay: String) {
        self.id = id
        self.title = title
        self.date = date
        self.start = start
        self.end = end
        self.creator = creator
        
        self.month = month
        self.year = year
        
        self.count = count
        
        setPrivacy(Int(privacy)!)
       // setAllDay(Int(allDay)!)
        
       // isInvitee()
        
    }
    
    func setPrivacy(_ p: Int){
        if(p == 0){
            isPrivate = false
        }else{
            isPrivate = true
        }
    }
    
    func setPrivacy(_ p: Bool){
        isPrivate = p
    }
    
    
   
    func isInvitee(){
        let calHandler = CalendarHandler()
     //   calHandler.isInvitee(Settings.sharedInstance.uid, forEvent: id, completion: {(invitee) in
            //print(invitee)
          //  self.isUserInvited = true //TODO: re-implement this
       // })
    }
    
    func isVisible() -> Bool{
//        if(isPrivate){
//            if(isUserInvited){
//                return true
//            }else{
//                return false
//            }
//        }else{
//            return true
//        }
        return false
    }
    
    func isHidden() -> Int{
        if(isPrivate){
          /*  if(creator == Settings.sharedInstance.uid){
                return 0
            }else{
                return 1
            }*/
            return 1
        }else{
            return 0
        }
    }
    
    func setAllDay(_ isAD: Int){
        if(isAD == 1){
            isAllDay = true
        }else{
            isAllDay = false
        }
    }
    
    func setAllDay(_ isAD: Bool){
        isAllDay = isAD
    }
    
    func getAllDayBool() ->Bool{
        
        return isAllDay
        
    }
    
    func getAllDayInt() ->Int{
        if(isAllDay){
            return 1
        }else{
            return 0
        }
    }
    
    func prefixedMonth() -> String{
        
        
        if( Int(month!)! < 10){
            return "0" + month!
        }else{
            return month!
        }
    }
    
    func getDate() -> Date{
        var dateString = self.date! + "/"
        dateString += prefixedMonth() + "/"
        dateString += self.year! + " "
        dateString += self.start!
        print(dateString)
        let date = DateFormatter()
        date.dateFormat = "dd/mm/yyyy HH:mm"
        let r = date.date(from: dateString)
        print(r)
        return r!
    }
    
    
 
}
