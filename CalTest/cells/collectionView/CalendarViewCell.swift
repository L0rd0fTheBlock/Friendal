//
//  CalendarViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 23/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {
    
    let date = UILabel()
    let dayCircle = CircleView()
    let eventCircle = CircleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        date.layer.cornerRadius = 25
        self.addSubview(date)
        
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.cornerRadius = 0
        border.frame = CGRect(x: 0, y: 0 + width, width: frame.width, height: width)
        border.borderWidth = 0.5
        layer.addSublayer(border)
        layer.masksToBounds = true
        
        date.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.height))
        date.textAlignment = .center
        
        self.addSubview(dayCircle)
        self.addSubview(eventCircle)
        generateCircles()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       
    }
    
    func generateCircles(){
        
        dayCircle.translatesAutoresizingMaskIntoConstraints = false
        eventCircle.translatesAutoresizingMaskIntoConstraints = false
        
        dayCircle.isToday = true
        dayCircle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayCircle.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        dayCircle.widthAnchor.constraint(equalToConstant: 20).isActive = true
        dayCircle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dayCircle.isHidden = true
        
        eventCircle.isToday = false
        eventCircle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        eventCircle.centerYAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        eventCircle.widthAnchor.constraint(equalToConstant: 20).isActive = true
        eventCircle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        eventCircle.isHidden = true
        
    }
    
}
