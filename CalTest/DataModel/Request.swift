//
//  Request.swift
//  CalTest
//
//  Created by Jamie McAllister on 29/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation

class Request{

    let event: Event
    let sender:String
    let message:String?
    var accepted: Int = 0
    var person: Person? = nil
    let id:String

    init(_ id:String, e: Event, s: String, m: String){
        
        event = e
        sender = s
        message = m
        self.id = id
        
    }
    
    init(_ id:String, e: Event, s: String){
        
        event = e
        sender = s
        message = nil
        self.id = id
    }
    
}
