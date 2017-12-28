//
//  NotificationRequestViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 29/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FacebookCore

class NotificationRequestViewCell: UITableViewCell {

    let title = UILabel()
    let timeLabel = UILabel()
    let pic = UIImageView()
    let accept = UIButton(type: .roundedRect)
    let decline = UIButton(type: .roundedRect)
    var id:String = "0"
    var table: NotificationViewController? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title.frame = CGRect(x: 70, y: 20, width: frame.width-75, height: 120)
        
        title.numberOfLines = 0
        
        //title.sizeToFit()
        
        timeLabel.frame = CGRect(x: 10, y: 90, width: frame.width, height: 30)
        
        pic.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        
        accept.tintColor = .green
        accept.frame = CGRect(x: 0, y: 120, width: (frame.width)/2, height: 30)
        accept.setTitle("Accept", for: .normal)
        accept.titleLabel?.font = accept.titleLabel?.font.withSize(30)
        var border = CALayer()
        var width = CGFloat(0.5)
        border.borderColor = UIColor.lightGray.cgColor
        border.cornerRadius = 0
        border.frame = CGRect(x: 0, y: 0 + width, width: accept.frame.width, height: accept.frame.height-width)
        border.borderWidth = 0.5
        accept.layer.addSublayer(border)
        accept.layer.masksToBounds = true
        accept.addTarget(self, action: #selector(didAccept) , for: .touchUpInside)
        
        
        accept.setTitleColor( UIColor.green, for: .normal)
        
        decline.tintColor = .red
        decline.frame = CGRect(x: frame.width/2, y: 120, width: (frame.width)/2, height: 30)
        decline.setTitle("Decline", for: .normal)
        decline.titleLabel?.font = decline.titleLabel?.font.withSize(30)
        border = CALayer()
        width = CGFloat(0.5)
        border.borderColor = UIColor.lightGray.cgColor
        border.cornerRadius = 0
        border.frame = CGRect(x: 0, y: 0 + width, width: decline.frame.width, height: decline.frame.height-width)
        border.borderWidth = 0.5
        decline.layer.addSublayer(border)
        decline.layer.masksToBounds = true
        
        decline.setTitleColor( UIColor.red, for: .normal)
        
        decline.addTarget(self, action: #selector(didDecline) , for: .touchUpInside)
        
        
        addSubview(title)
        addSubview(timeLabel)
        addSubview(pic)
        
        addSubview(accept)
        addSubview(decline)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didAccept(){
        print("Accepted")
        AppEventsLogger.log("Accepted Calendar Event with Friend")
        let calHandler = CalendarHandler()
        
        calHandler.acceptRequest(id)
        sleep(1)
        table?.loadData()
    }
    
    @objc func didDecline(){
        print("Declined")
        AppEventsLogger.log("Declined Calendar Event with Friend")
        let calHandler = CalendarHandler()
        
        calHandler.declineRequest(id)
        sleep(1)
        table?.loadData()
        
    }

}
