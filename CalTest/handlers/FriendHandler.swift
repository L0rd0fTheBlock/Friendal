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
    func getFriendsList(_ completion: @escaping ([Person])->Void){
        
        var friendList = [Person]()
        
        db.collection("friends").whereField("sender", isEqualTo: Auth.auth().currentUser!.uid).whereField("accepted", isEqualTo: true).getDocuments { snap, err in
            
            let docs = snap!.documents
            
            for document in docs{
                
                let data = document.data()
                let uid = data["target"] as! String //If the User's ID is in the sender Field then the Friend MUST be the target
                
                userHandler.getperson(withUID: uid) { p, b in
                    friendList.append(p)
                    completion(friendList)
                }
                
                
            }
            
            self.db.collection("friends").whereField("target", isEqualTo: Auth.auth().currentUser!.uid).whereField("accepted", isEqualTo: true).getDocuments { snap, err in
                let docs = snap!.documents
                
                for document in docs{
                    let data = document.data()
                    let uid = data["sender"] as! String //If the User's ID is in the target Field then the Friend MUST be the sender
                    
                    userHandler.getperson(withUID: uid) { p, b in
                        friendList.append(p)
                        completion(friendList)
                    }
                }
            }
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
    
    func sortFriendList() -> [Person]{
        
        
        
        
        
        return []
    }
    
}
