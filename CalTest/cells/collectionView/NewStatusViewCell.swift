//
//  NewStatusViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 09/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class NewStatusViewCell: UICollectionViewCell {
    
    let status = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        status.frame = .zero
        
        status.translatesAutoresizingMaskIntoConstraints = false
        addSubview(status)
        status.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        status.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        status.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        status.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        status.placeholder = "Say something..."
        
        status.borderStyle = .bezel
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
