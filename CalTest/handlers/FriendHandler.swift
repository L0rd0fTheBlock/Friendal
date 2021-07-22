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
    func getFriendsList(_ completion: @escaping ([Friend])->Void){
        
        var friendList = [Friend]()
        
        db.collection("friends").whereField("sender", isEqualTo: Auth.auth().currentUser!.uid).whereField("accepted", isEqualTo: true).getDocuments { snap, err in
            
            let docs = snap!.documents
            
            for friendship in docs{
                let data = friendship.data()
                let uid = data["target"] as! String //If the User's ID is in the target Field then the Friend MUST be the sender
                
                userHandler.getPersonAsFriend(withUID: uid) { document in
                    if(document != nil){
                        let friend = Friend(document: document!, withFriendId: friendship.documentID)
                        friendList.append(friend)
                        completion(friendList)
                    }
                }
            }
            
            self.db.collection("friends").whereField("target", isEqualTo: Auth.auth().currentUser!.uid).whereField("accepted", isEqualTo: true).getDocuments { snap, err in
                let docs = snap!.documents
                
                for friendship in docs{
                    let data = friendship.data()
                    let uid = data["sender"] as! String //If the User's ID is in the target Field then the Friend MUST be the sender
                    
                    userHandler.getPersonAsFriend(withUID: uid) { document in
                        if(document != nil){
                            let friend = Friend(document: document!, withFriendId: friendship.documentID)
                            friendList.append(friend)
                            completion(friendList)
                        }
                    }
                }
            }
        }
    }
    
    func getFriendRequests(_ completion: @escaping ([Friend])->Void){
        var requestList = [Friend]()
        db.collection("friends").whereField("target", isEqualTo: me.uid).whereField("accepted", isEqualTo: false).getDocuments { result, err in
            let docs = result!.documents
            print(docs.count)
            for request in docs{
                let data = request.data()
                let uid = data["sender"] as! String
                
                userHandler.getPersonAsFriend(withUID: uid) { document in
                    if(document != nil){
                        let request = Friend(document: document!, withFriendId: request.documentID)
                        requestList.append(request)
                        completion(requestList)
                    }else{
                        print("Nil Document in getPersonAsFriend completion Handler")
                    }
                }
            }
        }
    }
    
    func addFriend(withID: String, completion: @escaping ()->Void){
        self.db.collection("friends").addDocument(data: [
            "target": withID,
            "sender": me.uid,
            "accepted": false
        ]){_ in 
            completion()
        }
    }
    
    func removeFriend(withId: String, then: @escaping ()->Void){
        db.collection("friends").document(withId).delete { err in
            then()
        }
        }
    func acceptFriendRequest(){
        fatalError("Not Implemented Yet")
    }
    
    func rejectFriendRequest(){
        fatalError("Not Implemented Yet")
    }
    
}
