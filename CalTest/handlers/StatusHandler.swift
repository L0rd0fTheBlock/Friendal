//
//  StatusHandler.swift
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


class StatusHandler: Handler{
    func getStatus(forEvent: String, _ completion: @escaping([Status]) -> Void){
        var statuses = [Status]()
        //get all invites for the event
        db.collection("Status").whereField("eventID", isEqualTo: forEvent).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.isEmpty == true){
                    completion([])
                }
                for document in (querySnapshot?.documents)! {
                    let status = Status(document: document)
                    status.getPerson(p: document.data()["userID"] as! String, completion: {() in
                        statuses.append(status)
                        completion(statuses)
                    })
                }
            }
            
        }
    }
    
    func submitStatus(forEvent: String, fromUser: String, withMessage: String, _ completion: @escaping()->Void){
        let d = ["eventID": forEvent, "userID": fromUser, "message": withMessage]
        db.collection("Status").addDocument(data: d){(response) in
            completion()
        }
    }
}
