//
//  Settings.swift
//  CalTest
//
//  Created by Jamie McAllister on 31/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation
import FacebookCore

class Settings{
    
    var id:Int? = nil
    var uid:String = (AccessToken.current?.userId)!
    var dateFormat: Int = 1
    var privacy: Int = 0
    
    static let sharedInstance = Settings()
    
    init(){
        
    }
    
    func load(){
        let calHandler = CalendarHandler()
        
        calHandler.getSettings(forUser: uid)
    }
    
    func save(){
        
        let calHandler = CalendarHandler()
        calHandler.setSettings()
        
    }
    
    func getPrivacy() ->Bool{
        
        if(privacy == 0){
            return false
        }else{
            return true
        }
    }
    
    func setPrivacy(_ p: Bool){
        
        if(p == false){
            privacy = 0
        }else{
            privacy = 1
        }
    }
}
