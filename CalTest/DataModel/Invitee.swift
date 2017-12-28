//
//  Invitee.swift
//  CalTest
//
//  Created by Jamie McAllister on 22/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation


class Invitee{
    
    let id:String
    let UID:String
    var eventId:String
    var cancelled:String?
    var invitedBy: String?
    
    init(_ id:String, uid:String, eventId:String, isCancelled:String){
        
        self.id = id
        self.UID = uid
        self.eventId = eventId
        self.cancelled = isCancelled
    }
    
    init(_ id: String, uid: String, eventId: String, invitedBy: String) {
        self.id = id
        self.UID = uid
        self.eventId = eventId
        self.invitedBy = invitedBy
    }
    
    init(_ id: String, uid: String, eventId: String) {
        self.id = id
        self.UID = uid
        self.eventId = eventId
    }
    
    
}
