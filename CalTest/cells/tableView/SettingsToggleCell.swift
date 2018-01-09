//
//  FormToggleCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 31/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

class SettingsToggleCell: UITableViewCell {

    let toggle = UISwitch()
    let title = UILabel()
    
    
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
        toggle.setOn(Settings.sharedInstance.getPrivacy(), animated: true)
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
    
    @objc
    func didToggle(){
        print(toggle.isOn)
        Settings.sharedInstance.setPrivacy(toggle.isOn)
        Settings.sharedInstance.save()
    }

}
