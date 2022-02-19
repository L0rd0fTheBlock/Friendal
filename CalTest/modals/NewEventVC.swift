//
//  NewEventVC.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 27/11/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit
//import FBNotifications
//import FacebookCore
//import Crashlytics

class NewEventVC: UITableViewController {
    var calendarVC:CalendarViewController?
    var dayVC:DayViewController?
    var isAllDay: Bool = false
    var cells = 5
    let alert: UIAlertController = UIAlertController(title: "Invalid Duration", message: "An event cannot end at the same time (or earlier) than the start time.", preferredStyle: UIAlertController.Style.alert)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert.addAction(UIAlertAction(title: "Got It!", style: .default, handler: { (action: UIAlertAction!) in
            
            self.alert.dismiss(animated: true, completion: nil)
            
        }))
        
        tableView.register(FormTextCell.self, forCellReuseIdentifier: "text")
        tableView.register(FormDatePickerCell.self, forCellReuseIdentifier: "date")
        tableView.register(NewEventToggleCell.self, forCellReuseIdentifier: "toggle")
        
        tableView.rowHeight = 60.0
        tableView.allowsSelection = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
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
        var event = Event()
        
  //      Crashlytics.sharedInstance().setBoolValue(isAllDay, forKey: "isAllDay")
        
        if(isAllDay){
            event = getAllDayEvent()
        }else{
            event = getEventWithEndTime()
        }
        
        if(!isAllDay){
        
            if(event.start == event.end){
                present(alert, animated: true, completion: nil)
            }else{
                calendarHandler.addEvent(event: event){_ in
                    print("event Added")
                    self.dayVC?.doLoad()
                    self.calendarVC?.doLoad()
                }
                dismiss(animated: true, completion: nil)
            }
        }else{
            calendarHandler.addEvent(event: event){_ in
                self.dayVC?.doLoad()
                self.calendarVC?.doLoad()
            }
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
        
        if(isAllDay){
            return cellsForAllDay(indexPath: indexPath)
        }else{
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
                    
                    cell.value.date = dayVC!.today!.getDateAsDate()
                }else{
                   
                    cell.value.date = Date()
                    cell.showDate = true
                }
                return cell
            case 2://end
                let cell:FormDatePickerCell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath) as! FormDatePickerCell
                cell.desc.text = "End"
                if(dayVC != nil){
                    
                    cell.value.date = dayVC!.today!.getDateAsDate()
                }else{
                   
                    cell.value.date = Date()
                    cell.showDate = true
                }
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
        
        
    }

    func cellsForAllDay(indexPath: IndexPath) -> UITableViewCell{
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
               // cell.value.text = formatter.string(from: cell.startDate!)
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
              //  cell.value.text = formatter.string(from: Date())
                
                formatter.dateStyle = .short
                cell.shortDate = formatter.string(from: Date())
                
                formatter.dateStyle = .none
                cell.start = formatter.string(from: Date())
                cell.end = formatter.string(from: Date())
                
                cell.showDate = true
            }
            return cell
        case 2:

            let cell: NewEventToggleCell = tableView.dequeueReusableCell(withIdentifier: "toggle", for: indexPath) as! NewEventToggleCell
            cell.title.text = "Hide Event"
            cell.toggle.setOn(Settings.sharedInstance.getPrivacy(), animated: true)
            cell.parent = self
            return cell
        case 3:
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
        
        let dat = cell1.value.date
        let cal = Calendar.current
        event.date = String(describing: cal.component(.day, from: dat))
        event.month = String(describing: cal.component(.month, from: dat))
        event.year = String(describing: cal.component(.year, from: dat))
        
        event.start = String(describing: cal.component(.day, from: dat)) + "/" + String(describing: cal.component(.month, from: dat)) + "/" + String(describing: cal.component(.year, from: dat)) + " " + String(cal.component(.hour, from: dat)) + ":" + String(cal.component(.minute, from: dat))
        
        let cell2 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! NewEventToggleCell
        
        event.setPrivacy(cell2.toggle.isOn)
        
        let cell3 = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! NewEventToggleCell
        
        event.setAllDay(cell3.toggle.isOn)
        
        event.end = String(describing: cal.component(.day, from: dat)) + "/" + String(describing: cal.component(.month, from: dat)) + "/" + String(describing: cal.component(.year, from: dat)) + " " + "00" + ":" + "00"
        
        return event
    }
    
    func getEventWithEndTime() ->Event{
        let event = Event()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        //Get the title Cell
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTextCell
        event.title = cell.value.text //title
        
        //get the start time
        let cell1 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! FormDatePickerCell
        
        var dat = cell1.value.date
        
        //breakdown the start date
        let cal = Calendar.current
        event.date = String(describing: cal.component(.day, from: dat))
        event.month = String(describing: cal.component(.month, from: dat))
        event.year = String(describing: cal.component(.year, from: dat))
        
        event.start = formatter.string(from: dat)
        
        let cell2 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FormDatePickerCell
        dat = cell2.value.date
        
        event.end = formatter.string(from: dat)
        
        let cell3 = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! NewEventToggleCell
        
        event.setPrivacy(cell3.toggle.isOn)
        
        let cell4 = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! NewEventToggleCell
        
        event.setAllDay(cell4.toggle.isOn)
        
        
        return event
    }
    
    func hideEndTime(_ should: Bool){
        
        let path = IndexPath(row: 2, section: 0)
        if(should){
            isAllDay = should
            cells = cells - 1
            tableView.deleteRows(at: [path], with: .right)
            
        }else{
            isAllDay = should
            cells = cells + 1
            tableView.insertRows(at: [path], with: .left)
        }
        
    }
    
}
