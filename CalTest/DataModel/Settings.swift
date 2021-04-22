//
//  Settings.swift
//  CalTest
//
//  Created by Jamie McAllister on 31/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation

class Settings{
    
    var id:Int? = nil
    var me: Person = Person(id: "0", first: "", last: "")
    var dateFormat: Int = 1
    var privacy: Int = 0
    var selectedFriendId: String? = nil
    
    static let sharedInstance = Settings()
    
    init(){
        
    }
    
    func load(){
       // let calHandler = CalendarHandler()
        
       // calHandler.getSettings(forUser: uid)
        
      //  calHandler.doGraph(request: "me", params: "id, first_name, last_name", completion: {(person, error) in
            
         /*   guard let person = person else{
                return
            }
            
            self.me = Person(id: person["id"]as! String, first: person["first_name"] as! String, last: person["last_name"] as! String)
            
        })*/
        
        
    }
    
    func save(){
        
    //    let calHandler = CalendarHandler()
      //  calHandler.setSettings()
        
    }
    
    func getPrivacy() ->Bool{
        
       /* if(privacy == 0){
            return false
        }else{
            return true
        }*/
        return true
    }
    
    func setPrivacy(_ p: Bool){
        
      /*  if(p == false){
            privacy = 0
        }else{
            privacy = 1
        }*/
    }
}
