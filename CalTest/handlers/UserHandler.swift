//
//  UserHandler.swift
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

class UserHandler: Handler{
    
    func saveUser(person: Person){
        db.collection("User").document(person.uid).setData(person.toArray())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                self.saveProfilePicture(forUser: person.uid, withPicture: person.picture!)
            }
        }
    }
    
    func createUser(person: Person){
        count { c in
            person.friendCode = String(format: "%06d", c)
        }
        db.collection("User").document(Auth.auth().currentUser!.uid).setData(person.toArray())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                self.saveProfilePicture(forUser: Auth.auth().currentUser!.uid, withPicture: person.picture!)
            }
        }
    }
    
    func saveProfilePicture(forUser: String, withPicture: UIImage){
        
        //create reference
        let storageRef = storage.reference()
        
        //upload Image to cloud storage
        let picRef = storageRef.child("profiles/\(forUser)/profile.jpg")
        
        // Upload the file to the path
        let data = withPicture.jpegData(compressionQuality: 1)
        picRef.putData(data!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("something apparently went wrong")
            return
          }
        }

        
        
        
    }
    
   
    func doesUserExist(_ completion: @escaping (Bool)->Void){
        db.collection("User").document(Auth.auth().currentUser!.uid).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                fatalError("Unable to Retrieve documents to determine if user exists")
            } else {
                if(querySnapshot?.data() == nil){
                  //  print("User document does not exist, Instructing App to begin creation")
                    completion(false)
                }else{
                    completion(true)
                }
            }
        }
        
    }
    
    func getperson(forUser: String, completion: @escaping (_ p: Person)->Void){
        db.collection("User").document(forUser).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.data() != nil){
                    self.personWithPicture(from: querySnapshot!) { p in
                        completion(p)
                    }
                }
            }
        }
    }
    
    func getperson(withUID: String, completion: @escaping (Person, Bool)->Void){
        db.collection("User").document(withUID).getDocument(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.data() == nil){
                    let p = Person(id: "", first: "", last: "")
                    completion(p, false)
                }else{
                    let friend = Person(document: querySnapshot!)
                    completion(friend, true)
                }
            }
        })
        
    }
    
    func getperson(withCode: String, completion: @escaping (Person, Bool)->Void){
        db.collection("User").whereField("code", isEqualTo: withCode).getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.documents[0].data() == nil){
                    let p = Person(id: "", first: "", last: "")
                    completion(p, false)
                }else{
                    self.personWithPicture(from: querySnapshot!.documents[0]) { p in
                        completion(p, true)
                    }
                }
            }
        })
    }
    
    func getPersonAsFriend(withUID: String, completion: @escaping (DocumentSnapshot?)->Void){
        db.collection("User").document(withUID).getDocument(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot == nil){
                   completion(nil)
                }else{
                    completion(querySnapshot)
                }
            }
        })
    }
    
    func hasNotificationToken(matching token:String, completion: @escaping (Bool)->Void){
       // print("has notificaiton? for \(me.uid)")
        db.collection("User").document(me.uid).collection("tokens").whereField("token", isEqualTo: token).getDocuments { tokenDocumentSnap, err in
            //print("Got to hasNotification result")
            if(tokenDocumentSnap!.count > 0){
                completion(true)
            }else{
                completion(false)
            }
            
            
        }
    }
    
    func registerNotificationToken(token: String){
       // print("register Notification")
        //euXwTo6o00eVo9NKd1zvIx:APA91bGiCOLme4Z28QtWEc-ck2saoiS_1MJ6E2kAdkWjNuZYNRZPOq1BcEmNVwq_WyQeW4buiW-Pc2FvXHofEm33lR5YCzhAwzaZhgFTn46hkHPDB5k0-6KXsVd3zNiUmMaMexpvwaux//
        let today = Date()
        var components = DateComponents()
        components.month = 1
        
        let expires = Calendar.current.date(byAdding: components, to: today)
        
        let timestamp = Timestamp(date: expires!)
        
        
        db.collection("User").document(me.uid).collection("tokens").addDocument(data: [
            "token": token,
            "expires": timestamp
        ])
        
        
    }
    
    func personWithPicture(from: DocumentSnapshot, completion: @escaping (Person)->Void){
        let person = Person(document: from)
        // Create a reference to the file you want to download
        let storageRef = self.storage.reference()
        let picRef = storageRef.child("profiles/\(person.uid)/profile.jpg")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        picRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if error != nil {
            print("No Image Exists for this user")
            completion(person)
            // Uh-oh, an error occurred!
          } else {
            let image = UIImage(data: data!)
            person.picture = image
            completion(person)
          }
        }
    }
    
    func count(_ completion: @escaping(Int)->Void){
        db.collection("User").getDocuments { snap, err in
            completion(snap!.count)
        }
    }
    
    func getSettings(completion: @escaping (UserSettings)->Void){
        var shouldUpdate = false
        db.collection("Settings").document(me.uid).getDocument(completion: { snap, err in
            var settings = UserSettings()
            let data = snap?.data()
            if(data!["privacy"] != nil){
                settings.defaultPrivacy = data!["privacy"] as! Bool
            }else{
                shouldUpdate = true
            }
            //guard settings.termsDate = data[""]
        })
    }
}
