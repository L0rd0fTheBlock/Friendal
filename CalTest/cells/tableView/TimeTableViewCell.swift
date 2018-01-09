//
//  TimeTableViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 21/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    let label = UILabel()
    let eventLabel = UILabel()
    let border = CALayer()
    var event:Event?
    var isTitle = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventLabel.text = ""
        eventLabel.backgroundColor = .clear
        
        border.removeFromSuperlayer()
        self.backgroundColor = .white
        
        self.addSubview(label)
        self.addSubview(eventLabel)
       // label.textAlignment = .center
        
        label.frame = CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: self.frame.height))
        
        //label.frame = CGRect(x: 0, y: self.frame.height - (self.frame.height/2), width: 30, height: self.frame.height)
        
        let eventwidth = self.frame.width - CGFloat(50)
        eventLabel.frame = CGRect(x: 30, y: 0, width: eventwidth, height: self.frame.height)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEvent(forEvent: Event){
        event = nil
        event = forEvent
        eventLabel.backgroundColor = UIColor.yellow.withAlphaComponent(0.55)
        eventLabel.textAlignment = .center
        
        //create border for event label
        
        
        let width = CGFloat(1)
        border.borderColor = UIColor.orange.cgColor
        border.cornerRadius = 0
        border.frame = CGRect(x: 0, y: 0 + width, width: width, height: frame.height)
        border.borderWidth = width
        eventLabel.layer.addSublayer(border)
        eventLabel.layer.masksToBounds = true
        
        print(event?.title as Any)
        if(isTitle){
            let minute = event?.start?.components(separatedBy: ":").flatMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            if(minute![1] != 00){
                let eventHeight = (self.frame.height/CGFloat(60/Int(minute![1])))*CGFloat(-1)
                let eventwidth = self.frame.width - CGFloat(50)
                eventLabel.frame = CGRect(x: 30, y: self.frame.height+20, width: eventwidth, height: eventHeight-20)
            }
        }else{
            let eventwidth = self.frame.width - CGFloat(50)
            eventLabel.frame = CGRect(x: 30, y: 0, width: eventwidth, height: self.frame.height)
            
            eventLabel.backgroundColor = UIColor.yellow.withAlphaComponent(0.55)
            
           // eventLabel.backgroundColor = UIColor(red: CGFloat(208.0/255.0), green: CGFloat(189.0/255.0), blue: CGFloat(12.0/255.0), alpha: CGFloat(10.0/255.0))
            
            print(CGFloat(208.0/255.0))
        }
        
    }

}
