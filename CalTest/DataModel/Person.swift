//
//  Person.swift
//  CalTest
//
//  Created by Jamie McAllister on 27/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import Contacts

import FirebaseFirestore

class Person{
    var uid: String
    var first_name: String
    var last_name: String
    var email: String
    var mobile: String
    var picture: UIImage? = nil
    var link: String
    var friends: [Person] = [Person]()
    
    init(id: String, first: String, last: String, picture: Dictionary<String, Any>) {
        uid = id
        first_name = first
        last_name = last
        link = picture["url"] as! String
        email = ""
        mobile = ""
        
        
    }
    
    init(id: String, first: String, last: String) {
        uid = id
        first_name = first
        last_name = last
        link = ""
        email = ""
        mobile = ""
        
    }
    init(id: String, first: String, last: String, email:String, mobile:String) {
        uid = id
        first_name = first
        last_name = last
        link = ""
        self.email = email
        self.mobile = mobile
        
    }
    
    init(document: DocumentSnapshot){
        uid = document.documentID
        let d = document.data()
        first_name = d!["forename"] as! String
        last_name = d!["surname"] as! String
        link = ""
        email = d!["email"] as! String
        mobile = d!["mobile"] as! String
        
    }
    
    func name() -> String {
        return first_name + " " + last_name
    }
    
    func toArray() -> [String:String]{
        var person = [String:String]()
        
       // person["uid"] = uid
        person["forename"] = first_name
        person["surname"] = last_name
        person["email"] = email
        person["mobile"] = mobile
        
        return person
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func getContactImage() -> UIImage{
        
       let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: mobile))
        let keys = [CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor]
        
        let store = CNContactStore()
        do {
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            print("Fetched contacts: \(contacts)")
            
            let contact = contacts[0]
            if(contact.imageDataAvailable == true){
                picture = UIImage(data: contact.imageData!)!
                return picture!
            }else{
                picture = UIImage(named: "default_profile")
                return picture!
            }
        } catch {
            print("Failed to fetch contact, error: \(error)")
            // Handle the error
        }
        
        return UIImage()
    }
    
    func downloadImage(url: URL, table: UITableView) {
       
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.picture = UIImage(data: data)!
                table.reloadData()
            }
        }
    }
}

