//
//  LogoutButtonCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 23/05/2021.
//  Copyright © 2021 Jamie McAllister. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogoutButtonCell: UITableViewCell{
    
    var button: UIButton
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        button = UIButton()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        button.setTitle("Logout", for: .normal)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints(){
        
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -50).isActive = true
        button.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        
    }
}
