//
//  EventViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 02/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
//import FacebookCore
//import Crashlytics

class EventViewController: UITableViewController {

    var cells = 6
    var event:Event? = nil
    var today: DayViewController? = nil
    var count = 0
    var isEdit:Bool = false
    var isMyCalendar = true
    var isFromRequest = false
    var requestId: String?
    let alert: UIAlertController = UIAlertController(title: "Delete", message: "Are you sure? This cannot be undone.", preferredStyle: UIAlertController.Style.alert)
    let warning: UIAlertController = UIAlertController(title: "Invalid end time", message: "The end time must not be the same or before the start time.", preferredStyle: UIAlertController.Style.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteHandler.getRequestCount(forEvent: event!.id, completion: { (c) in
            
            self.count = c
            self.tableView.reloadData()
            
        })
        
        
        hideKeyboardWhenTappedAround()
        
        if(isMyCalendar){
            let delete = UIButton()
            view.isUserInteractionEnabled = true
           // delete.backgroundColor = .red
            //delete.titleLabel?.text = "Delete"
            delete.setTitle("Delete", for: .normal)
            delete.setTitleColor(.red, for: .normal)
            delete.tintColor = .white
            
         //   delete.addTarget(self, action: #selector(didDelete), for: .touchUpInside)
            
            delete.frame = CGRect(x: 0, y: view.frame.height - 100/*-125*/, width: view.frame.width, height: 50)
            view.addSubview(delete)
        }
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        
        tableView.allowsSelection = true
        
        if(!isFromRequest){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didBeginEditing))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Respond", style: .plain, target: self, action: #selector(willRespond))
        }
        registerCells()
        self.tabBarController?.tabBar.isHidden = true
        
        alert.addAction(UIAlertAction(title: "I'm Sure", style: .default, handler: { (action: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        warning.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
    }

    override func viewWillAppear(_ animated: Bool) {
        title = event?.title
        tabBarController?.hidesBottomBarWhenPushed = false
    }
    
    @objc func willRespond(){
        
        let notificationAlert = NotificationResponseAlert(forRequest: requestId!, sender: self)
        
        let alert = notificationAlert.alertWithoutView()
        present(alert, animated: true, completion: nil)
    }
    
    func registerCells(){
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "eventItem")
        tableView.register(StatusTableViewCell.self, forCellReuseIdentifier: "status")
        tableView.register(FormTextCell.self, forCellReuseIdentifier: "textCell")
        tableView.register(FormDatePickerCell.self, forCellReuseIdentifier: "dateCell")
        tableView.register(NewEventToggleCell.self, forCellReuseIdentifier: "toggleCell")
        tableView.register(SelectableTableViewCell.self, forCellReuseIdentifier: "selectableCell")
    }

    // MARK: - Table view data source

    @objc func didBeginEditing(){
        
        if(!isEdit){
            self.navigationItem.rightBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didBeginEditing))
            isEdit = true
            tableView.separatorStyle = .singleLine
        }else{
            if(saveEvent()){
                isEdit = false
                tableView.separatorStyle = .none
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didBeginEditing))
            }
            }
        
        
        tableView.reloadData()
    }
    
    func saveEvent() -> Bool{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY HH:mm"
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTextCell
        event?.title = cell.value.text
        
        let startCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FormDatePickerCell
        
        var dat = startCell.value.date
        let cal = Calendar.current
        event?.date = String(describing: cal.component(.day, from: dat))
        event?.month = String(describing: cal.component(.month, from: dat))
        event?.year = String(describing: cal.component(.year, from: dat))
        
        event?.start = formatter.string(from: dat)
        
        let endCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! FormDatePickerCell
        
        dat = endCell.value.date
        event?.end = formatter.string(from: dat)
        
        let hideCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! NewEventToggleCell
        event?.isPrivate = hideCell.toggle.isOn
        
        if(event?.getAllDayBool())!{
            
            calendarHandler.update(event: event!, withId: event!.id)
            return true
        }else{
            if(event?.getStartTime() == event?.getEndTime()){
                navigationController?.present(warning, animated: true, completion: {
                })
                return false
            }else{
                calendarHandler.update(event: event!, withId: event!.id)
                return true
            }
        }
    }
    
    @objc func didDelete(){
        
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cells
    }

    
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //MARK: customize cell sizes for map and address(?)
    if(!isEdit){
    switch indexPath.row{
        case 5:
            return CGFloat(200)
        default:
            return tableView.rowHeight
        }
    }else{
        return 50
    }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(isEdit){
            return getEditCell(indexPath: indexPath)
        }else{
            return getDisplayCell(indexPath: indexPath)
        }
    }
    
    
    func getEditCell(indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! FormTextCell
            cell.value.text = event?.title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! FormTextCell
            cell.value.text = ""
            return cell
        case 2://start
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! FormDatePickerCell
            cell.desc.text = "Start"
            cell.showDate = true
            cell.value.date = event!.getStartDate()
            cell.showDate = true

            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! FormDatePickerCell
            cell.desc.text = "End"
            cell.showDate = true
            //cell.value.date = event!.getEndDate()
            cell.value.setDate(event!.getEndDate(), animated: true)
            cell.showDate = true
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "toggleCell", for: indexPath) as! NewEventToggleCell
            cell.parent = self
            cell.type = 1
            cell.title.text = "Hide Event"
            cell.toggle.isOn = (event?.isPrivate)!
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "toggleCell", for: indexPath) as! NewEventToggleCell
            cell.parent = self
            cell.type = 1
            cell.title.text = "All-Day"
            cell.toggle.isOn = (event?.isAllDay)!
            
            return cell
        default:
            return UITableViewCell()
            
        }
        
    }
    
    func getDisplayCell(indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventItem", for: indexPath) as! TextTableViewCell
                cell.title.frame = CGRect(x: 30, y: 20, width: cell.frame.width, height: cell.frame.height)
                cell.title.font = UIFont.boldSystemFont(ofSize: 30)
                cell.title.text = event?.title
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventItem", for: indexPath) as! TextTableViewCell
                cell.title.frame = CGRect(x: 30, y: 10, width: cell.frame.width, height: cell.frame.height)
                cell.title.text = ""
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventItem", for: indexPath) as! TextTableViewCell
                cell.title.frame = CGRect(x: 30, y: 10, width: cell.frame.width - 35, height: cell.frame.height)
                cell.title.text = "Start: "
                cell.value.frame = CGRect(x: 30, y: 10, width: cell.frame.width - 60, height: cell.frame.height)
                cell.value.textAlignment = .right
                cell.value.text = event?.start
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventItem", for: indexPath) as! TextTableViewCell
                cell.title.frame = CGRect(x: 30, y: 10, width: cell.frame.width, height: cell.frame.height)
                cell.title.text = "End: "
                cell.value.frame = CGRect(x: 30, y: 10, width: cell.frame.width - 60, height: cell.frame.height)
                cell.value.textAlignment = .right
                cell.value.text = event?.end
    
                return cell
            case 4:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "selectcell")
                cell.textLabel?.text = "Invitees "
                cell.detailTextLabel?.text = "\(count) Going"
                cell.accessoryType = .disclosureIndicator
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "status") as! StatusTableViewCell
                cell.collectionView.event = self.event
                cell.collectionView.doLoad()
                cell.collectionView.rootView = self
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventItem", for: indexPath)
                return cell
        }
    
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if(!isEdit){
            if(indexPath.row == 4){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        let inviteeView = InviteesTableViewController()
        
        if(event != nil){
           inviteeView.event = event
           navigationController?.pushViewController(inviteeView, animated: true)
        }
    }
    
    func hideEndTime(_ should: Bool){
        let path = IndexPath(row: 3, section: 0)
        if(should){
            cells = cells - 1
            tableView.deleteRows(at: [path], with: .right)
            
        }else{
            if(cells < 6){
                cells = cells + 1
                tableView.insertRows(at: [path], with: .left)
            }
        }
        event?.setAllDay(should)
    }
    
    func dateString(_ date:String) ->String{
        if(date.first == "0"){
        switch date{
            case "01":
                return "January"
            case "02":
                return "February"
            case "03":
                return "March"
            case "04":
                return "April"
            case "05":
                return "May"
            case "06":
                return "June"
            case "07":
                return "July"
            case "08":
                return "August"
            case "09":
                return "September"
            default:
                return "Error"
        }
        }else{
            switch date{
            case "1":
                return "January"
            case "2":
                return "February"
            case "3":
                return "March"
            case "4":
                return "April"
            case "5":
                return "May"
            case "6":
                return "June"
            case "7":
                return "July"
            case "8":
                return "August"
            case "9":
                return "September"
            case "10":
                return "October"
            case "11":
                return "November"
            case "12":
                return "December"
            default:
                return "ERROR"
            }
        }
    }
    
    func daySuffix(_ day:String) -> String{
        switch day{
        case "1":
            return "st"
        case "2":
            return "nd"
        case "3":
            return "rd"
        default:
            return "th"
        }
    }
    
    @objc func keyboardWillShow(){
        if(!isEdit){
            var contentOffset:CGPoint = tableView.contentOffset
            contentOffset.y  = tableView.contentOffset.y + 200
            
            tableView.contentOffset = contentOffset
        }
    }
    
    @objc func keyboardWillHide(){
        if(!isEdit){
            var contentOffset:CGPoint = tableView.contentOffset
            contentOffset.y  = tableView.contentOffset.y - 200
            
            tableView.contentOffset = contentOffset
        }
    }
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
