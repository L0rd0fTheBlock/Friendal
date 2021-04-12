//
//  NewRequestVC.swift
//  CalTest
//
//  Created by Jamie McAllister on 30/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
//import FBNotifications
//import FacebookCore
//import Crashlytics

class NewRequestVC: NewEventVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @objc override func didSave(){
        let handler = CalendarHandler()
        var event = Event()
        
//        Crashlytics.sharedInstance().setBoolValue(isAllDay, forKey: "isAllDay")
        
        if(isAllDay){
            event = getAllDayEvent()
        }else{
            event = getEventWithEndTime()
        }
        
        if(!isAllDay){
            
            if(event.start == event.end){
                present(alert, animated: true, completion: nil)
            }else{
                print("saving....")
                handler.saveNewEvent(event: event, completion:{(data) in
                    print(data)
                    print(Settings.sharedInstance.selectedFriendId)
                    handler.saveNewRequest(event: data, user: (Settings.sharedInstance.selectedFriendId)!, name: "null", isNotMe: false)
                })
                dismiss(animated: true, completion: nil)
            }
        }else{
            print("saving....")
            handler.saveNewEvent(event: event, completion:{(data) in
                print(data)
                print(Settings.sharedInstance.selectedFriendId)
                handler.saveNewRequest(event: data, user: (Settings.sharedInstance.selectedFriendId)!, name: "null", isNotMe: false)
            })
            dismiss(animated: true, completion: nil)
        }
    }

}
