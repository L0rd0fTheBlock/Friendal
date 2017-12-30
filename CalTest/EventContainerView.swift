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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
        backgroundColor = UIColor.yellow.withAlphaComponent(0.55)
        label.backgroundColor = UIColor.orange
        
        let border = CALayer()
        
        let width = CGFloat(3)
        border.borderColor = UIColor.orange.cgColor
        border.cornerRadius = 0
        border.frame = CGRect(x: 0, y: 0 + width, width: width, height: self.frame.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        label.textAlignment = .center
        
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
