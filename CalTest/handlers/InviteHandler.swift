//
//  InviteHandler.swift
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

class InviteHandler: Handler{
    
   
    
    func saveNewRequest(event: String, user: String, day: Int, month: Int, year: Int, completion: @escaping ()->Void){
        db.collection("Invite").addDocument(data: ["eventId":event, "target":user, "sender": Auth.auth().currentUser!.uid, "response": "no", "day": day, "month": month, "year": year])
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                completion()
               // self.sendMessage(to: user, type: 1, withRef: ref!)
            }
        }
    }
    
    func isUserInvited(_ user: String, toEvent: String, completion: @escaping(Bool)->Void){
        
        db.collection("Invite").whereField("eventId", isEqualTo: toEvent).whereField("target", isEqualTo: user).getDocuments { snap, err in
            
            let docs = snap!.count
            if(docs > 0){
                completion(true)
            }else{
                completion(false)
            }
            
            
            
        }
    }
    
    func getRequests(forEvent: String, completion: @escaping ([Person], [Person], [Person])->Void){
        var going = [Person]()
        var notGoing = [Person]()
        var invited = [Person]()
        //get all invites for the event
        db.collection("Invite").whereField("eventId", isEqualTo: forEvent).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.isEmpty == true){
                    completion([], [], [])
                }
                for document in (querySnapshot?.documents)! {
                    let data = document.data()
                    //get the user data for the invitee
                    userHandler.getperson(withUID: data["target"] as! String, completion: { (p, e) in
                       // put the user in the correct array
                        switch data["response"] as! String{
                        case "going":
                            going.append(p)
                            break
                        case "not":
                            notGoing.append(p)
                            break
                        default:
                            invited.append(p)
                        }
                        completion(going, notGoing, invited)
                    })
                        
                }
            }
        }
        
    }
    
    func getRequests(forUser: String, completion: @escaping ([Request]) -> Void){
        
        var requests = [Request]()
        
        db.collection("Invite").whereField("target", isEqualTo: forUser).whereField("response", isEqualTo: "no").getDocuments(completion: {(querySnapshot, err) in
            if(querySnapshot?.isEmpty == true){
                completion([])
            }
            for document in (querySnapshot?.documents)! {
                let r = Request()
                let d = document.data()
                r.apply(document: document)
                userHandler.getperson(forUser: d["sender"] as! String, completion: {(p) in
                    r.person = p
                    calendarHandler.getEvent(withId: d["eventId"] as! String, completion: {(e) in
                        r.event = e
                        requests.append(r)
                        completion(requests)
                    })
                })
                
            }
            
        })
        
    }
    
    func getRequestCount(forEvent: String, completion: @escaping (Int)->Void){
        var going = 0
        //get all invites for the event
        db.collection("Invite").whereField("eventId", isEqualTo: forEvent).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.isEmpty == true){
                    completion(0)
                }
                for document in (querySnapshot?.documents)! {
                    let data = document.data()
                    //get the user data for the invitee
                    userHandler.getperson(withUID: data["target"] as! String, completion: { (p, e) in
                       // put the user in the correct array
                        if(data["response"] as! String == "going"){
                            going += 1
                        
                        }
                        completion(going)
                        })
                }
            }
        }
        
    }
    
    func respondToRequest(_ request: String, with: String, completion: @escaping ()->Void){
        
        db.collection("Invite").document(request).updateData(["response" : with]){_ in
            completion()
        }
    }
    
    func removeRequest(foruser: String, fromEvent: String){
        
        db.collection("Invite").whereField("eventId", isEqualTo: fromEvent).whereField("target", isEqualTo: foruser).getDocuments(completion: {(querySnapshot, err) in
            
            for document in (querySnapshot!.documents){
                let id = document.documentID
                    self.db.collection("Invite").document(id).delete()
            }
            
        })
    }
    
    func getRequestEvents(forUser: String, onDay: Int, ofMonth: Int, inYear: Int, completion: @escaping ([Event]) -> Void){
        
        var events = [Event]()
        
        db.collection("Invite").whereField("target", isEqualTo: forUser)
            .whereField("response", isEqualTo: "going")
            .whereField("day", isEqualTo: onDay)
            .whereField("month", isEqualTo: ofMonth)
            .whereField("year", isEqualTo: inYear)
            .getDocuments(completion: {(querySnapshot, err) in
            if(querySnapshot?.isEmpty == true){
                completion([])
            }else{
                for document in (querySnapshot?.documents)! {
                    let d = document.data()
                    calendarHandler.getEvent(withId: d["eventId"] as! String, completion: {(e) in
                        events.append(e)
                        completion(events)
                    })
                }
            }
        })
        
    }
}
