//
//  Request.swift
//  CalTest
//
//  Created by Jamie McAllister on 29/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Request{

    var event: Event
    var message:String?
    var accepted: String = "no"
    var person: Person? = nil
    var id:String

    init(_ id:String, e: Event, m: String){
        
        event = e
        message = m
        self.id = id
        
    }
    
    init(_ id:String, e: Event, s: String){
        
        event = e
        message = nil
        self.id = id
    }
    
    init(){
        event = Event()
        message = ""
        id = ""
    }
    
    func apply(document: DocumentSnapshot){
        let d = document.data()!
        message = d["message"] as? String
        accepted = d["response"] as! String
        id = document.documentID
        
    }
}
