//
//  Person.swift
//  CalTest
//
//  Created by Jamie McAllister on 27/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

import FirebaseFirestore

class Person{
    var uid: String
    var first_name: String
    var last_name: String
    var email: String
    var mobile: String
    var name: String
    var picture: UIImage? = nil
    var link: String
    var friends: [Person] = [Person]()
    
    init(id: String, first: String, last: String, picture: Dictionary<String, Any>) {
        uid = id
        first_name = first
        last_name = last
        name = first + " " + last
        link = picture["url"] as! String
        email = ""
        mobile = ""
        
        
    }
    
    init(id: String, first: String, last: String) {
        uid = id
        first_name = first
        last_name = last
        name = first + " " + last
        link = ""
        email = ""
        mobile = ""
        
    }
    init(id: String, first: String, last: String, email:String, mobile:String) {
        uid = id
        first_name = first
        last_name = last
        name = first + " " + last
        link = ""
        self.email = email
        self.mobile = mobile
        
    }
    
    init(document: DocumentSnapshot){
        uid = document.documentID
        let d = document.data()
        first_name = d!["forename"] as! String
        last_name = d!["surname"] as! String
        name = first_name + " " + last_name
        link = ""
        email = d!["email"] as! String
        mobile = d!["mobile"] as! String
        
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

