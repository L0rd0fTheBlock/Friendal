//
//  NotificationResponseAlert.swift
//  CalTest
//
//  Created by Jamie McAllister on 05/05/2021.
//  Copyright © 2021 Jamie McAllister. All rights reserved.
//

import UIKit

class NotificationResponseAlert{
    let requestID: String
    var nVc : NotificationViewController? = nil
    var eVc : EventViewController? = nil
    
    init(){
        requestID = ""
    }
    
    init(forRequest: String, sender: NotificationViewController){
        requestID = forRequest
        nVc = sender
    }
    init(forRequest: String, sender: EventViewController){
        requestID = forRequest
        eVc = sender
    }
    
   func alertWithView(_ handler: @escaping (UIAlertAction)->Void) -> UIAlertController{
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Accept", style: .default, handler: accept)
        action.setValue(UIColor.systemGreen, forKey: "titleTextColor")
        alert.addAction(UIAlertAction(title: "View", style: .default, handler: handler))
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Decline", style: .destructive, handler: decline))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
    
    func alertWithoutView() -> UIAlertController{
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Accept", style: .default, handler: accept)
        action.setValue(UIColor.systemGreen, forKey: "titleTextColor")
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Decline", style: .destructive, handler: decline))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
    
    func accept(action: UIAlertAction){
        let inviteHandler = InviteHandler()
        inviteHandler.respondToRequest(requestID, with: "going"){() in
            if(self.eVc == nil){
                //do notificaiton controller actions
                self.nVc?.loadData()
            }else{
                //do event controller actions
                self.eVc?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func decline(action: UIAlertAction){
        let inviteHandler = InviteHandler()
        inviteHandler.respondToRequest(requestID, with: "not"){() in
            if(self.eVc == nil){
                //do notificaiton controller actions
                self.nVc?.loadData()
            }else{
                //do event controller actions
                self.eVc?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
