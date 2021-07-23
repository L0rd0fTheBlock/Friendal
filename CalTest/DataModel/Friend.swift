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
    
    var friendshipID: String = ""
    
    override init(){
        friendshipID = ""
        super.init()
    }
    
    init(document: DocumentSnapshot, withFriendId: String) {
        friendshipID = withFriendId
        super.init(document: document)
    }
    
    init(_ p: Person, withFriendId: String){
        super.init(id: p.uid, first: p.first_name, last: p.last_name, email: p.email, picture: p.picture!, code: p.friendCode)
        friendshipID = withFriendId
    }
    
    
}
