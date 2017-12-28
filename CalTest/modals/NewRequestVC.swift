//
//  NewRequestVC.swift
//  CalTest
//
//  Created by Jamie McAllister on 30/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
//import FBNotifications
import FacebookCore

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
        let event = Event()
        
        AppEventsLogger.log("Added Calendar Event With Friend")
        //Get the title Cell
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTextCell
        event.title = cell.value.text
        
        let cell1 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! FormDatePickerCell
        
        let dat = cell1.shortDate
        let date = dat?.split(separator: "/") as Array<Substring>!
        
        event.date = String(describing: date![0])
        event.month = String(describing: date![1])
        let year = date![2].split(separator: ",")
        event.year = String(describing: year[0])
        
        event.start = cell1.start
        
        let cell2 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FormDatePickerCell
        
        /*
 
         CREATE REQUEST
         CREATE EVENT WITH TARGET USER ID
         WHEN ACCEPTED CHANGE EVENT FROM CANECLLED
         WHEN ACCEPTED DUPLICATE EVENT WITH SENDER USER ID
         
         
         */
        
        event.end = cell2.end
        
        
        handler.saveNewEvent(event: event, completion:{(data) in
            print(data)
            handler.saveNewRequest(event: data, user: (self.calendarVC?.nonUserUID)!)
        })
        
        
        dismiss(animated: true, completion: nil)
    }

}
