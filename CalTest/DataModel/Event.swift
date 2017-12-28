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
    
    init(_ id: String, title: String, date: String, month: String, year: String, start: String, end: String, count: String, creator: String) {
        self.id = id
        self.title = title
        self.date = date
        self.start = start
        self.end = end
        self.creator = creator
        
        self.month = month
        self.year = year
        
        self.count = count
    }
    
    init(){
        id = "0"
    }
}
