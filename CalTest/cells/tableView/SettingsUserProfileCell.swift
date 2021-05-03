//
//  SettingsUserProfileCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 03/05/2021.
//  Copyright © 2021 Jamie McAllister. All rights reserved.
//

import UIKit

class SettingsUserProfileCell: UITableViewCell{
    let name = UILabel(frame: .zero)
    let pic = UIImageView(frame: .zero)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //layout the Pic Frame
        pic.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pic)
        
        pic.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        pic.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        pic.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        pic.rightAnchor.constraint(equalTo: contentView.leftAnchor, constant: 100).isActive = true
        
        //Layout the Name label
        name.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(name)
        
        name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        name.leftAnchor.constraint(equalTo: pic.rightAnchor, constant: 20).isActive = true
        name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        name.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        name.textAlignment = .left
        name.font = UIFont(name: name.font.fontName, size: 24)
        name.adjustsFontSizeToFitWidth = true
        
        
        self.accessoryType = .disclosureIndicator
        
    }
    required init?(coder: NSCoder) {
        fatalError("Not yet Implemented")
    }
    
    func didTap(){
        
    }
}
