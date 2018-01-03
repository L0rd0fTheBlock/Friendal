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
    
    init(_ id: String, title: String, date: String, month: String, year: String, start: String, end: String, count: String, creator: String, privacy: String) {
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
        
        isInvitee()
        
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
    
    func isInvitee(){
        let calHandler = CalendarHandler()
        calHandler.isInvitee(Settings.sharedInstance.uid, forEvent: id, completion: {(invitee) in
            print(invitee)
            self.isUserInvited = invitee
        })
    }
    
    func isHidden() -> Int{
        if(isPrivate){
            if(creator == Settings.sharedInstance.uid){
                return 0
            }else{
                return 1
            }
        }else{
            return 0
        }
    }
    
    init(){
        id = "0"
    }
}
