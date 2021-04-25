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
        setupBackground()
        
    }
    
    init(forEvent: Event, today: DayViewController) {
        super.init(frame: CGRect())
        event = forEvent
        self.today = today
        
        setupBorder()
        setupLabel()
        setupGuestures()
        setupBackground()
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        event = nil
        super.init(coder: aDecoder)
    }
    
    
    //MARK: Setup Functions
    
    func setupBackground(){
        if(event?.isAllDay == true){
            backgroundColor = .orange
        }else{
            backgroundColor = UIColor.yellow.withAlphaComponent(0.55)
        }
    }
    
    func setupBorder(){
        
        addBorders(edges: .left, color: .orange, inset: 0, thickness: 5)
        addBorders(edges: .top, color: .orange, inset: 0, thickness: 30)
        
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
       // label.backgroundColor = UIColor.orange
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


extension UIView{
    
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }
    
}

