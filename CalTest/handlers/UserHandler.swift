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
        print(person.toArray())
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
                    print("User document does not exist, Instructing App to begin creation")
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
                    let person = Person(document: querySnapshot!)
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
            }
        }
    }
    
    func getperson(forPhone: String, completion: @escaping (Person, Bool)->Void){
        db.collection("User").whereField("mobile", isEqualTo: forPhone).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.isEmpty == true){
                    let p = Person(id: "", first: "", last: "")
                    completion(p, false)
                }
                for document in (querySnapshot?.documents)! {
                    let person = Person(document: document)
                    //Get profile Pic
                    let storageRef = self.storage.reference()
                    let picRef = storageRef.child("profiles/\(person.uid)/profile.jpg")

                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    picRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                      if error != nil {
                        print("No Image Exists for this user")
                        completion(person, true)
                        // Uh-oh, an error occurred!
                      } else {
                        let image = UIImage(data: data!)
                        person.picture = image
                        completion(person, true)
                      }
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
    
}
