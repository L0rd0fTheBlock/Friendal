//
//  NotificationRequestViewCell.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 29/11/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit
//import FacebookCore

class NotificationRequestViewCell: UITableViewCell {
    let senderLabel = UILabel()
    let descriptionLabel = UILabel()
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    let senderPic = UIImageView()
    var id:String = "0"
    var table: NotificationViewController? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSender()
        setupDesc()
        setupTitle()
        setupTime()
        
        /*title.frame = CGRect(x: 70, y: 20, width: frame.width-75, height: 120)
        
        title.numberOfLines = 0
        
        title.sizeToFit()
        
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
        addSubview(decline)*/
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupSender(){
        
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(senderLabel)
        
        senderPic.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(senderPic)
        
        senderPic.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        senderPic.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        senderPic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        senderPic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        senderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        senderLabel.leftAnchor.constraint(equalTo: senderPic.rightAnchor, constant: 10).isActive = true
        senderLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        senderLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
       // senderLabel.addBorders(edges: .all, color: .black)
        senderLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
    }
    
    func setupTitle(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: senderPic.bottomAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //titleLabel.addBorders(edges: .all, color: .black)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
    }
    
    func setupDesc(){
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 3).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: senderPic.rightAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //descriptionLabel.addBorders(edges: .all, color: .black)
        
        
    }

    func setupTime(){
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: senderPic.rightAnchor, constant: 10).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //timeLabel.addBorders(edges: .all, color: .black)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
