//
//  Person.swift
//  CalTest
//
//  Created by Jamie McAllister on 27/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

class Person{
    var uid: String
    var first_name: String
    var last_name: String
    var name: String
    var picture: UIImage? = nil
    var link: String
    
    init(id: String, first: String, last: String, picture: Dictionary<String, Any>) {
        uid = id
        first_name = first
        last_name = last
        name = first + " " + last
        link = picture["url"] as! String
        
        
    }
    
    init(id: String, first: String, last: String) {
        uid = id
        first_name = first
        last_name = last
        name = first + " " + last
        link = ""
        
        
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

