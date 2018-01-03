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
    
    var allDayLabel: UIView {
        let adView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 35))
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: 80, height: 35))
        label.text = "All-Day"
        label.textColor = .white
        
        adView.backgroundColor = .gray
        
        adView.addSubview(label)
        
        return adView
    }
    
    let cellID: String = "event"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(allDayLabel)
        
        for (index, event) in (today?.events.enumerated())!{
            
            var overlap = 1
            var shift = 0
            let start = makeMinutes(from: event.start!)
            let end = makeMinutes(from: event.end!)
            let id = event.id
            
            
            overlap = calculateOverlap(start: start, end: end, id: id)
            
            if(index>0){
                shift = calculateShift(index, start: start, end: end)
            }
            
            drawEvent(event, overlaps: overlap, shiftBy: shift)
        }// end drawdrawEvent loop
        
        for i in -1...23 {
            drawTime(i)
        }
    }
    
    func drawTime(_ index: Int){
        if(index == -1){
        }else{
            let label = UILabel(frame: CGRect(x: 0, y: (50 * (index+1)) - 25, width: 30, height: 50)  )
            label.text = String(format: "%02d", index)
            tableView.addSubview(label)
        }
    }
    
    func drawEvent(_ event:Event, overlaps:Int, shiftBy:Int){
        if(event.isAllDay){
            let spacer: CGFloat = CGFloat(5) //the space between all day events
            let eventWidth = (tableView.frame.width - 80) / CGFloat(overlaps)
            let shift = (eventWidth + spacer) * CGFloat(shiftBy)
            
           let frame = CGRect(x: CGFloat(75 + shift), y: 5, width: eventWidth, height: 25)
            
            let eventView = EventContainerView(withFrame: frame, forEvent: event, today: self)
            allDayLabel.addSubview(eventView)
            
        }else{
            let start = makeMinutes(from: event.start!)
            let end = makeMinutes(from: event.end!)
            
            let tableLength = 50*25
            let breakdown = CGFloat(tableLength) / CGFloat(1500) //split the table into it's minutes
            
            let startPoint: CGFloat = breakdown * CGFloat(start + 60) // multiply by the start time to push the event down the view
            let duration = CGFloat(end) - CGFloat(start)
            
            let endpoint = breakdown * duration
            
            let eventWidth = (tableView.frame.width - 30) / CGFloat(overlaps)
            
            let shift = eventWidth * CGFloat(shiftBy)
            var frame: CGRect
            if(shiftBy > 0){
                frame = CGRect(x: CGFloat(30 + (5*shiftBy)) + shift, y: startPoint, width: eventWidth, height: endpoint)
                
            }else{
                frame = CGRect(x: CGFloat(30) + shift, y: startPoint, width: eventWidth, height: endpoint)
                
            }
            
            let eventView = EventContainerView(withFrame: frame, forEvent: event, today: self)
            tableView.addSubview(eventView)
        }
    }
    
    
    func calculateShift(_ index: Int, start: Int, end: Int) -> Int{
        var shift = 0
        let count = index - 1
        
        for i in 0...count{
            let event = today?.events[i]
            if(start <= makeMinutes(from: (event?.start!)!) && end >= makeMinutes(from: (event?.start!)!)){
                shift = shift + 1
            }else if(start > makeMinutes(from: (event?.start!)!) && start < makeMinutes(from: (event?.end!)!)){
                shift = shift + 1
            }
        }
        return shift
    }
    
    func calculateOverlap(start: Int, end: Int, id: String) -> Int{
        var overlap = 1
        for event in (today?.events)!{
            if(event.id == id){
            }else{
                if(makeMinutes(from: event.start!) >= start && makeMinutes(from: event.start!) <= end){
                      overlap = overlap + 1
                    
                }else if(makeMinutes(from: event.end!) >= start && makeMinutes(from: event.start!) <= end){//if ends after event starts and starts before the event ends
                    overlap = overlap + 1
                }
            }
        }
        return overlap
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        return cell
    }//end function
    
    //MARK: Helper functions
    
    func makeMinutes(from: String) -> Int{
        
        let time = from.split(separator: ":")
        
        let htm:Int = Int(String(describing: time[0]))! * 60 //hour to minutes
        
        let minutes = htm + Int(String(describing: time[1]))!
        
        return minutes
        
    }
    
}
