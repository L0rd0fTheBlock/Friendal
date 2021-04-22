//
//  EventContainerView.swift
//  CalTest
//
//  Created by Jamie McAllister on 29/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

class EventContainerView: UIView {

    let label:UILabel = UILabel()
    var event:Event?
    var today: DayViewController? = nil
    
    init(withFrame: CGRect, forEvent: Event, today: DayViewController) {
        event = forEvent
        self.today = today
        
        super.init(frame: withFrame)
        
        setupLabel()
        setupBorder()
        setupGuestures()
        
        backgroundColor = UIColor.yellow.withAlphaComponent(0.55)
    }
    
    init(forEvent: Event, today: DayViewController) {
        super.init(frame: CGRect())
        event = forEvent
        self.today = today
        setupLabel()
        setupBorder()
        setupGuestures()
        
        backgroundColor = UIColor.yellow.withAlphaComponent(0.55)
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        event = nil
        super.init(coder: aDecoder)
    }
    
    
    //MARK: Setup Functions
    
    func setupBorder(){
        
        let border = CALayer()
        let width = CGFloat(3)
        border.borderColor = UIColor.orange.cgColor
        border.cornerRadius = 0
        border.frame = CGRect(x: 0, y: 0 + width, width: width, height: self.frame.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
    func setupLabel(){
        
      //  label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            label.widthAnchor.constraint(equalTo: self.widthAnchor),
            //label.heightAnchor.constraint(equalTo: self.heightAnchor)
        ]
        
     //   label.backgroundColor = UIColor.orange
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        print("======WRITING LABEL========")
        if(event?.isVisible())!{
            print("Event is visible")
            label.text = event?.title
        }else{
            print("event is NOT visible")
            label.text = "Busy"
        }
        
        
        
        addSubview(label)
    }
    
    func setupGuestures(){
        let tapper = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapper.isEnabled = true
        addGestureRecognizer(tapper)
    }
    
    //MARK: GuestureHandlers
    
    
    @objc
    func didTap(){
        if(event?.isVisible())!{
            let eventView = EventViewController()
            
            if(event != nil){
                eventView.event = event
                eventView.today = today
                eventView.isMyCalendar = (today?.shouldLoadMyCalendar)!
                today?.navigationController?.pushViewController(eventView, animated: true)
            }
        }else{
            let alert = UIAlertController(title: "Private Event", message: "You cannot view details about this event.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }) )
            today?.present(alert, animated: true, completion: nil)
        }
    }
    
}
