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
                        self.generateFriend(from: document!, with: friendship.documentID) { friend in
                            friendList.append(friend)
                            completion(friendList)
                        }
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
                            self.generateFriend(from: document!, with: friendship.documentID) { friend in
                                friendList.append(friend)
                                completion(friendList)
                            }
                            
                            
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
            for request in docs{
                let data = request.data()
                let uid = data["sender"] as! String

                userHandler.getPersonAsFriend(withUID: uid) { document in
                    if(document != nil){
                        
                        self.generateFriend(from: document!, with: request.documentID) { f in
                            requestList.append(f)
                            completion(requestList)
                        }
                        
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
    func acceptFriendRequest(withID: String, completion: @escaping ()->Void){
        db.collection("friends").document(withID).updateData(["accepted": true]) { err in
            completion()
        }
    }
    
    func rejectFriendRequest(withID: String, completion: @escaping ()->Void){
        db.collection("friends").document(withID).delete(){_ in
            completion()
        }
    }
    
    func generateFriend(from document: DocumentSnapshot, with id: String, completion: @escaping (Friend)->Void){
        userHandler.personWithPicture(from: document) { p in
            let friend = Friend(p, withFriendId: id)
            friend.friendshipID = id
            completion(friend)
        }
    }
}
