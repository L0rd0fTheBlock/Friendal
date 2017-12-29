//
//  DayViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 20/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

class DayViewController: UITableViewController {
    
    var drawEvent:Event? = nil
    
    var today: CalendarDay?{
        didSet{
            navigationItem.title = today?.getFullDate()
        }
    }
    
    let cellID: String = "event"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.register(TimeTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
       // tableView.isUserInteractionEnabled = false
        //tableView.allowsSelection = false
    }
    func setupView(){
        view.backgroundColor = .white
        //view.addSubview(tableView)
        //tableView.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: view.frame.height)
        for event in (today?.events)!{
            drawEvent(event)
        }
    }
    
    func drawEvent(_ event:Event){
        
        let start = makeMinutes(from: event.start!)
        let end = makeMinutes(from: event.end!)
        
        let tableLength = 50*25
        let breakdown = CGFloat(tableLength) / CGFloat(1440) //split the table into it's minutes
        
        let startPoint: CGFloat = breakdown * CGFloat(start) // multiplyy by the start time to push the event down the view
        
        print(start)
        print(end)
        print(CGFloat(end) - CGFloat(start))
        print(startPoint)
        print(startPoint + CGFloat(end))
        
        let frame = CGRect(x: CGFloat(30), y: startPoint, width: tableView.frame.width - 30, height: CGFloat(end) - CGFloat(start))
        
        let eventView = UIView(frame: frame)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: eventView.frame.width, height: 30))
        
        label.text = event.title
        
        label.backgroundColor = UIColor.orange
        
        eventView.backgroundColor = UIColor.yellow.withAlphaComponent(0.55)
        label.textAlignment = .center
        
        eventView.addSubview(label)
        
        tableView.addSubview(eventView)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TimeTableViewCell
        cell.awakeFromNib()
        cell.selectionStyle = .none
        let index = indexPath.row - 1
        if(indexPath.row == 0){
            cell.label.text = ""
        }else{
            cell.label.text = String(format: "%02d", index)
            for event in (today?.events)!{
               var isSet = false
                let start = event.start?.split(separator: ":")
                let end = event.end?.split(separator: ":")
                if(start![0] == String(format: "%02d", index)){//event is starting
                    cell.selectionStyle = .default
                    
                    cell.isTitle = true
                    //cell.setEvent(forEvent: event)
                     //isSet = true
                   // cell.eventLabel.text = event.title
                }else if(Int(String(start![0]))! < index && Int(String(end![0]))! > index){//event has started
                    cell.selectionStyle = .default
                    
                    cell.isTitle = false
                    if(Int(String(end![0]))! > index){//event has not ended
                        cell.selectionStyle = .default
                        cell.isTitle = false
                      //  cell.setEvent(forEvent: event)
                       // isSet = true
                        
                    }
                }
                
                
                if(Int(String(end![0]))! == index){//event has ended
                    
                    cell.isTitle = false
                    if(!isSet){
                       // cell.setEvent(forEvent: event)
                    }
                    let end = event.end?.components(separatedBy: ":").flatMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                    if(end![1] == 00){
                        cell.eventLabel.backgroundColor = .white
                    }else{
                        let eventwidth = cell.frame.width - CGFloat(50)
                        let eventY = (cell.frame.height/CGFloat(60/Int(end![1])))*CGFloat(-1)
                        cell.eventLabel.frame = CGRect(x: 30, y: eventY, width: eventwidth, height: cell.frame.height)
                    }
                }//end if event has ended
            }//end for
        }//end if cell not 0
        return cell
    }//end function
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TimeTableViewCell
        
        tableView.deselectRow(at: indexPath, animated: true)
        let eventView = EventViewController()
        
        if(cell.event != nil){
            eventView.event = cell.event
            eventView.today = self
            navigationController?.pushViewController(eventView, animated: true)
        }
    }
    
    //MARK: Helper functions
    
    func makeMinutes(from: String) -> Int{
        
        let time = from.split(separator: ":")
        
        let htm:Int = Int(String(describing: time[0]))! * 60 //hour to minutes
        
        let minutes = htm + Int(String(describing: time[1]))!
        
        return minutes
        
    }
    
}
