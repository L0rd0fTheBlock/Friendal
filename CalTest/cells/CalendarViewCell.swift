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
        
        //print("init")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       
    }
    
}
