//
//  Event.swift
//  CalTest
//
//  Created by Jamie McAllister on 20/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class Event{
    let id: String
    var title: String?
    var date: String?
    var month: String?
    var year: String?
    var start: Date?
    var end: Date?
    var creator: String?
    var notes: String? = nil
    var count: String = "0"
    var invitees:[String] = []
    var location: String? = nil
    var canInvite: Bool = false
    var isPrivate: Bool = false//false = visible, true = "busy"
    var isUserInvited: Bool = false
    var isAllDay: Bool = true
    var bridgesDays: Bool = false
    var isBridge = false
    
    init(){
        id = "0"
        creator = Auth.auth().currentUser!.uid
        bridgesDays = false
    }
    
    init(_ id: String, title: String, date: String, month: String, year: String, start: Date, end: Date, count: String = "0", creator: String, privacy: String, allDay: String) {
        self.id = id
        self.title = title
        self.date = date
        self.start = start
        self.end = end
        self.creator = creator
        
        self.month = month
        self.year = year
        
        self.count = count
        self.bridgesDays = doesEventBridgeDays()
        //MARK: re-implement these functions
        setPrivacy(Int(privacy)!)
        setAllDay(Int(allDay)!)
        
       // isInvitee()
        
    }
    
    init(document: DocumentSnapshot) {
        self.id = document.documentID
        let d = document.data()
        self.title = d!["title"] as? String
        
        let stamp = d!["start"] as? Timestamp
        let estamp = d!["end"] as? Timestamp
        
        self.start = stamp?.dateValue()
        self.end = estamp?.dateValue()
        
        self.creator = d!["user"] as? String
        
        self.isAllDay = (d!["isAllDay"] as? Bool)!
        
        self.isPrivate = d!["isPrivate"] as! Bool
        
        self.count = (d!["count"] as? String)!
        
        self.date = d?["day"] as? String
        self.month = d?["month"] as? String
        self.year = d?["year"] as? String
        
        self.bridgesDays = doesEventBridgeDays()
        //MARK: re-implement these functions
        
        isInvitee()
        
    }
    
    private func doesEventBridgeDays() -> Bool{
        print("====Does \(title) bridge Days====")
        
        print("====start====")
        print("day: \(getStartDay()), month: \(getStartMonth()), year: \(getStartYear())")
        print("====end====")
        print("day: \(getEndDay()), month: \(getEndMonth()), year: \(getEndYear())")
        
        
        if(getStartDay() != getEndDay() || getStartMonth() != getEndMonth() || getStartYear() != getEndYear()){//if the event ends tomorrow then set the bottom anchor rather than the height
            print("bridging Days")
            return true
        }else{
            print("Not Bridging Days")
            return false
        }
        
        print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
    }
    
    public func toArray() -> [String:Any]{
        var ev = [String:Any]()
        ev["title"] = title
        ev["day"] = date ?? "00"
        ev["month"] = month ?? "00"
        ev["year"] = year ?? "00"
        ev["start"] = start
        ev["end"] = end
        ev["user"] = creator
        ev["notes"] = notes
        ev["count"] = count
        //ev["invitees"]
        ev["isPrivate"] = isPrivate
        ev["isAllDay"] = isAllDay
        return ev
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
    
    func getStartDay() -> String{
        
        let calendar = Calendar.current
        
        return String(describing: calendar.component(.day, from: start!))
        
    }
    func getStartMonth() -> String{
        let calendar = Calendar.current
        
        return String(describing: calendar.component(.month, from: start!))
    }
    func getStartYear() -> String{
        let calendar = Calendar.current
        
        return String(describing: calendar.component(.year, from: start!))
    }
    func getStartTime() -> String{
        let calendar = Calendar.current
        let timeString = String(describing: calendar.component(.hour, from: start!)) + ":" + String(describing: calendar.component(.minute, from: start!))
        return timeString
    }
   
    func getEndDay() -> String{
        let calendar = Calendar.current
        return String(describing: calendar.component(.day, from: end!))
    }
    func getEndMonth() -> String{
        let calendar = Calendar.current
        return String(describing: calendar.component(.month, from: end!))
    }
    func getEndYear() -> String{
        let calendar = Calendar.current
        return String(describing: calendar.component(.year, from: end!))
    }
    func getEndTime() -> String{
        let calendar = Calendar.current
        let timeString = String(describing: calendar.component(.hour, from: end!)) + ":" + String(describing: calendar.component(.minute, from: end!))
        return timeString
    }
    
    func isInvitee(){
        let inviteHandler = InviteHandler()
        
        
        inviteHandler.isUserInvited(Auth.auth().currentUser!.uid, toEvent: id) { r in
            self.isUserInvited = r
        }
    }
    
    func isVisible() -> Bool{
        if(isPrivate){
            if(isUserInvited){
                return true
            }else{
                return false
            }
        }else{
            return true
        }
        
    }
    
    func isHidden() -> Int{
        if(isPrivate){
            if(creator == Auth.auth().currentUser?.uid){
                return 0
            }else{
                return 1
            }
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
    
    func getStartDate() -> Date{
        
        return start!
    }
    
    func getEndDate() -> Date{
        
        return end!
    }
    
    func getStartDateString() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: start!)
    }
    
    func getEndDateString() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: end!)
    }
    
    
    
 
}
