//
//  StatusViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 09/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class StatusViewCell: UICollectionViewCell {
    
    let picture: UIImageView = UIImageView()
    let message: UITextView = UITextView()
    let poster: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picture.frame = .zero
        message.frame = .zero
        poster.frame = .zero
        
        addSubview(picture)
        addSubview(message)
        addSubview(poster)
        
//        picture.backgroundColor = .red
//        message.backgroundColor = .blue
//        poster.backgroundColor = .yellow
        
        poster.font = UIFont.boldSystemFont(ofSize: 24)
        message.font = UIFont.systemFont(ofSize: 18)
        
        message.translatesAutoresizingMaskIntoConstraints = false
        picture.translatesAutoresizingMaskIntoConstraints = false
        poster.translatesAutoresizingMaskIntoConstraints = false
        
        picture.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        picture.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        picture.widthAnchor.constraint(equalToConstant: 50).isActive = true
        picture.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        poster.leftAnchor.constraint(equalTo: picture.rightAnchor, constant: 5).isActive = true
        poster.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        poster.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        poster.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        message.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 10).isActive = true
        message.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        message.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        message.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
