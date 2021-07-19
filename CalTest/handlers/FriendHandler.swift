//
//  FriendHandler.swift
//  CalTest
//
//  Created by Andrew McAllister on 19/07/2021.
//  Copyright © 2021 MakeItForTheWeb Ltd. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FriendHandler: Handler{
    func getFriendsList(){
        db.collection("friends").whereField("sender", isEqualTo: Auth.auth().currentUser!.uid).whereField("accepted", isEqualTo: true).getDocuments { shapshot, err in
        }
    }
    
    func addFriend(){
        fatalError("Not Implemented Yet")
    }
    
    func removeFriend(){
            fatalError("Not Implemented Yet")
        }
    func acceptFriendRequest(){
        fatalError("Not Implemented Yet")
    }
    
    func rejectFriendRequest(){
        fatalError("Not Implemented Yet")
    }
    
}
