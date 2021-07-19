//
//  Friend.swift
//  CalTest
//
//  Created by Andrew McAllister on 19/07/2021.
//  Copyright © 2021 MakeItForTheWeb Ltd. All rights reserved.
//

import Foundation

import Firebase
import FirebaseFirestoreSwift

class Friend: Person{
    
    let friendshipID: String
    
    override init(){
        friendshipID = ""
        super.init()
    }
    
    init(document: DocumentSnapshot, withFriendId: String) {
        friendshipID = withFriendId
        super.init(document: document)
    }
    
}
