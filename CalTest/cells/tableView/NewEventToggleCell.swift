//
//  NewEventToggleCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 01/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class NewEventToggleCell: UITableViewCell {

    let toggle = UISwitch()
    let title = UILabel()
    var parent: NewEventVC?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print(toggle.frame.width)
        print(toggle.frame.height)
        
        let subtraction = toggle.frame.height / 2
        
        title.frame = CGRect(x: 10, y: 0, width: frame.width - 100, height: frame.height)
        
        toggle.frame = CGRect(x: frame.width - 70, y: (frame.height / 2) - subtraction, width: frame.width, height: frame.height)
        
        toggle.addTarget(self, action: #selector(didToggle), for: .touchUpInside)
        addSubview(toggle)
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didToggle() {
        print("toggle")
        if(title.text == "All-Day" && toggle.isOn){
            parent?.hideEndTime(true)
//            parent?.tableView.reloadData()
        }else{
            parent?.hideEndTime(false)
        }
        
    }

}
