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
    var picture: UIImage? = nil
    var friendCode: String
    
    init(id: String, first: String, last: String, picture: Dictionary<String, Any>) {
        uid = id
        first_name = first
        last_name = last
        email = ""
        friendCode = ""
        self.picture = UIImage(named: "default_profile")
        
        
    }
    
    init(id: String, first: String, last: String) {
        uid = id
        first_name = first
        last_name = last
        email = ""
        friendCode = ""
        picture = UIImage(named: "default_profile")
        
    }
    init(id: String, first: String, last: String, email:String) {
        uid = id
        first_name = first
        last_name = last
        self.email = email
        friendCode = ""
        picture = UIImage(named: "default_profile")
        
    }
    
    init(id: String, first: String, last: String, email:String, picture: UIImage, code: String) {
        uid = id
        first_name = first
        last_name = last
        self.email = email
        friendCode = code
        self.picture = picture
        
    }
    
    
    init(document: DocumentSnapshot){
        uid = document.documentID
        let d = document.data()
        first_name = d!["forename"] as! String
        last_name = d!["surname"] as! String
        email = d!["email"] as! String
        picture = UIImage(named: "default_profile")
        friendCode = d!["code"] as! String
        
        
    }
    
    init() {
        uid = ""
        first_name = ""
        last_name = ""
        email = ""
        picture = UIImage(named: "default_profile")
        friendCode = ""
    }
    
    func name() -> String {
        
        if(uid == me.uid){
            return "\(first_name) \(last_name) (You)"
        }else{
            return first_name + " " + last_name
        }
    }
    
    func toArray() -> [String:String]{
        var person = [String:String]()
        
        person["forename"] = first_name
        person["surname"] = last_name
        person["email"] = email
        person["code"] = friendCode
        
        return person
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func generateQRCode() -> UIImage? {
        let data = friendCode.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

}

