//
//  Status.swift
//  CalTest
//
//  Created by Jamie McAllister on 08/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import Foundation

struct Status: Decodable{
    
    let id: String?
    let poster: String?
    let message: String?
    //let posted: Date
    var name: String?
    var link: String?
    var comments: [Comment]?
    var isAd: Bool? = false
    
}

struct Comment: Decodable{
    let id: String
    let poster: String
    let message: String
   // let posted: String
}
