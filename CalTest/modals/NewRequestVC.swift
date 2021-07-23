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
        let inviteHandler = InviteHandler()
        var event = Event()
        
//        Crashlytics.sharedInstance().setBoolValue(isAllDay, forKey: "isAllDay")
        
        if(isAllDay){
            event = getAllDayEvent()
        }else{
            event = getEventWithEndTime()
        }
        
        if(!isAllDay){
            
            if(event.getStartTime() == event.getEndTime()){
                present(alert, animated: true, completion: nil)
            }else{
                
                calendarHandler.addEvent(event: event, completion: {(eventId) in
                    if(eventId == "Error"){
                        print("Error")
                    }else{
                        inviteHandler.saveNewRequest(event: eventId, user: Settings.sharedInstance.selectedFriendId!, day: Int(event.date!)!, month: Int(event.month!)!, year: Int(event.year!)!){
                            if(self.calendarVC != nil){
                                self.calendarVC!.doLoad()
                            }else{
                                self.dayVC?.doLoad()
                            }
                        }
                    }
                })

                dismiss(animated: true, completion: nil)
            }
        }else{
            
            calendarHandler.addEvent(event: event, completion: {(eventId) in
                if(eventId == "Error"){
                    print("Error")
                }else{
                    inviteHandler.saveNewRequest(event: eventId, user: Settings.sharedInstance.selectedFriendId!, day: Int(event.date!)!, month: Int(event.month!)!, year: Int(event.year!)!){
                        self.calendarVC?.doLoad()
                    }
                }
            })
           
            dismiss(animated: true, completion: nil)
        }
    }

}
