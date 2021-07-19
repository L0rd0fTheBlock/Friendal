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
        creator = Auth.auth().currentUser!.uid
    }
    
    init(_ id: String, title: String, date: String, month: String, year: String, start: String, end: String, count: String = "0", creator: String, privacy: String, allDay: String) {
        self.id = id
        self.title = title
        self.date = date
        self.start = start
        self.end = end
        self.creator = creator
        
        self.month = month
        self.year = year
        
        self.count = count
        //MARK: re-implement these functions
        setPrivacy(Int(privacy)!)
        setAllDay(Int(allDay)!)
        
       // isInvitee()
        
    }
    
    init(document: DocumentSnapshot) {
        self.id = document.documentID
        let d = document.data()
        self.title = d!["title"] as? String
        
        self.start = d!["start"] as? String
        self.end = d!["end"] as? String
        
        self.creator = d!["user"] as? String
        
        self.isAllDay = (d!["isAllDay"] as? Bool)!
        
        self.isPrivate = d!["isPrivate"] as! Bool
        
        self.count = (d!["count"] as? String)!
        
        self.date = d?["day"] as? String
        self.month = d?["month"] as? String
        self.year = d?["year"] as? String
        
        //MARK: re-implement these functions
        
        isInvitee()
        
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
        let split = start?.split(separator: "/")
        return String(describing: split![0])
        
    }
    func getStartMonth() -> String{
        let split = start?.split(separator: "/")
        return String(describing: split![1])
    }
    func getStartYear() -> String{
        let split = start?.split(separator: "/")
        let yearTime = split![2].split(separator: " ") // without this split[2] will look like "YYYY HH:mm"
        return String(describing: yearTime[0])
    }
    func getStartTime() -> String{
        let split = start?.split(separator: "/")
        let yearTime = split![2].split(separator: " ") // without this split[2] will look like "YYYY HH:mm"
        return String(describing: yearTime[1])
    }
   
    func getEndDay() -> String{
        let split = end?.split(separator: "/")
        return String(describing: split![0])
    }
    func getEndMonth() -> String{
        let split = end?.split(separator: "/")
        return String(describing: split![0])
    }
    func getEndYear() -> String{
        let split = end?.split(separator: "/")
        let yearTime = split![2].split(separator: " ") // without this split[2] will look like "YYYY HH:mm"
        return String(describing: yearTime[0])
    }
    func getEndTime() -> String{
        let split = end?.split(separator: "/")
        let yearTime = split![2].split(separator: " ") // without this split[2] will look like "YYYY HH:mm"
        return String(describing: yearTime[1])
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
        print("START: \(start!)")
        let date = DateFormatter()
        date.dateFormat = "dd/MM/yyyy HH:mm"
        let r = date.date(from: start!)
        print("r: \(r!)")
        return r!
    }
    
    func getEndDate() -> Date{
        
        let date = DateFormatter()
        date.dateFormat = "dd/MM/yyyy HH:mm"
        let r = date.date(from: end!)
        return r!
    }
    
    
    
    
 
}
