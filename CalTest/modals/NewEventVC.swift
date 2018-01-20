//
//  NewEventVC.swift
//  CalTest
//
//  Created by Jamie McAllister on 27/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
//import FBNotifications
import FacebookCore

class NewEventVC: UITableViewController {
    var calendarVC:CalendarViewController?
    var dayVC:DayViewController?
    var isAllDay: Bool = false
    var cells = 5
    let alert: UIAlertController = UIAlertController(title: "Invalid Duration", message: "An event cannot end at the same time (or earlier) than the start time.", preferredStyle: UIAlertControllerStyle.alert)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert.addAction(UIAlertAction(title: "Got It!", style: .default, handler: { (action: UIAlertAction!) in
            
            self.alert.dismiss(animated: true, completion: nil)
            
        }))
        
        tableView.register(FormTextCell.self, forCellReuseIdentifier: "text")
        tableView.register(FormDatePickerCell.self, forCellReuseIdentifier: "date")
        tableView.register(NewEventToggleCell.self, forCellReuseIdentifier: "toggle")
        
        tableView.rowHeight = 60.0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        self.title = "Add Event"
        
        let buttonLeft = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancel) )
        
        navigationItem.setLeftBarButton(buttonLeft, animated: true)
        
        let buttonRight = UIBarButtonItem(barButtonSystemItem: .save , target: self, action: #selector(didSave))
        
        navigationItem.setRightBarButton(buttonRight, animated: true)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    @objc func didCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSave(){
        
        
        AppEventsLogger.log("Added Calendar Event")
        let handler = CalendarHandler()
        var event = Event()
        
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
                handler.saveNewEvent(event: event, completion: {(id) in })
                dismiss(animated: true, completion: nil)
            }
        }else{
            print("saving....")
            handler.saveNewEvent(event: event, completion: {(id) in })
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.row {
        case 0://title
            let cell:FormTextCell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
            cell.value.placeholder = "Title"
            
            return cell
        case 1://start
            let cell:FormDatePickerCell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath) as! FormDatePickerCell
            cell.desc.text = "Start"
            cell.showDate = true
            if(dayVC != nil){
                cell.startDate = dayVC?.today?.getDateAsDate()
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                cell.value.text = formatter.string(from: cell.startDate!)
                formatter.dateStyle = .none
                cell.start = formatter.string(from: cell.startDate!)
                cell.end = formatter.string(from: cell.startDate!)
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                cell.shortDate = formatter.string(from: cell.startDate!)
                cell.showDate = true
                
            }else{
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                cell.value.text = formatter.string(from: Date())
                
                formatter.dateStyle = .short
                cell.shortDate = formatter.string(from: Date())
                
                formatter.dateStyle = .none
                cell.start = formatter.string(from: Date())
                cell.end = formatter.string(from: Date())
                
                cell.showDate = true
            }
            return cell
        case 2://end
            let cell:FormDatePickerCell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath) as! FormDatePickerCell
            cell.desc.text = "End"
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .short
        
                cell.value.text = formatter.string(from: Date())
                formatter.dateStyle = .none
                cell.start = formatter.string(from: Date())
                cell.end = formatter.string(from: Date())
                cell.showDate = false
            return cell
        case 3:

            let cell: NewEventToggleCell = tableView.dequeueReusableCell(withIdentifier: "toggle", for: indexPath) as! NewEventToggleCell
            cell.title.text = "Hide Event"
            cell.toggle.setOn(Settings.sharedInstance.getPrivacy(), animated: true)
            cell.parent = self
            return cell
        case 4:
            let cell: NewEventToggleCell = tableView.dequeueReusableCell(withIdentifier: "toggle", for: indexPath) as! NewEventToggleCell
            cell.title.text = "All-Day"
            cell.parent = self
            return cell
        default:
            print("error")
            return UITableViewCell()
        }
    }

    
    
    func getAllDayEvent() -> Event{
        let event = Event()
        //Get the title Cell
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTextCell
        event.title = cell.value.text
        
        let cell1 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! FormDatePickerCell
        
        let dat = cell1.shortDate
        let date = dat?.split(separator: "/") as Array<Substring>!
        print(date)
        event.date = String(describing: date![0])
        event.month = String(describing: date![1])
        let year = date![2].split(separator: ",")
        event.year = String(describing: year[0])
        
        event.start = cell1.start
        
        let cell2 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! NewEventToggleCell
        
        event.setPrivacy(cell2.toggle.isOn)
        
        let cell3 = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! NewEventToggleCell
        
        event.setAllDay(cell3.toggle.isOn)
        
        event.end = "00:00"
        
        return event
    }
    
    func getEventWithEndTime() ->Event{
        let event = Event()
        
        //Get the title Cell
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTextCell
        event.title = cell.value.text
        
        let cell1 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! FormDatePickerCell
        
        let dat = cell1.shortDate
        let date = dat?.split(separator: "/") as Array<Substring>!
        print(date)
        event.date = String(describing: date![0])
        event.month = String(describing: date![1])
        let year = date![2].split(separator: ",")
        event.year = String(describing: year[0])
        
        event.start = cell1.start
        
        let cell2 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FormDatePickerCell
        
        event.end = cell2.end
        
        let cell3 = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! NewEventToggleCell
        
        event.setPrivacy(cell3.toggle.isOn)
        
        let cell4 = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! NewEventToggleCell
        
        event.setAllDay(cell4.toggle.isOn)
        
        
        return event
    }
    
    func hideEndTime(_ should: Bool){
        let path = IndexPath(row: 2, section: 0)
        if(should){
            cells = cells - 1
            tableView.deleteRows(at: [path], with: .right)
            
        }else{
            cells = cells + 1
            tableView.insertRows(at: [path], with: .left)
        }
        isAllDay = should
    }
    
}
