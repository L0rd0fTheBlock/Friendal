//
//  User.swift
//  CalTest
//
//  Created by Andrew McAllister on 21/07/2021.
//  Copyright © 2021 MakeItForTheWeb Ltd. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging

class User: Person{
    
    override init() {
        super.init()
    }
    
    override init(document: DocumentSnapshot) {
        super.init(document: document)
        validateToken()
    }
    
    func validateToken(){
        
        Messaging.messaging().token { token, error in
           if let error = error {
             print("Error fetching FCM registration token: \(error)")
           } else if let token = token {
             print("FCM registration token: \(token)")
            userHandler.hasNotificationToken(matching: token) { result in
                if(!result){
                    userHandler.registerNotificationToken(token: token)
                }
            }
           //  self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
           }
         }
    }
    
    
}
