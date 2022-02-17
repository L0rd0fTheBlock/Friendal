//
//  NewEventToggleCell.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 01/01/2018.
//  Copyright © 2018 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit

class NewEventToggleCell: UITableViewCell {

    let toggle = UISwitch()
    let title = UILabel()
    var parent: UITableViewController?
    var type: Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let subtraction = toggle.frame.height / 2
        
        title.frame = CGRect(x: 10, y: 0, width: frame.width - 100, height: frame.height)
        
        toggle.frame = CGRect(x: frame.width - 70, y: (frame.height / 2) - subtraction, width: frame.width, height: frame.height)
        
        toggle.addTarget(self, action: #selector(didToggle), for: .touchUpInside)
        contentView.addSubview(toggle)
        //addSubview(toggle)
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
        if(type == 0){
            let p = parent as! NewEventVC
            if(title.text == "All-Day" && toggle.isOn){
                
                p.hideEndTime(true)
                parent?.tableView.reloadData()
            }else if(title.text == "All-Day" && !toggle.isOn){
                p.hideEndTime(false)
            }
        }else if(type == 1){
            let p = parent as! EventViewController
            if(title.text == "All-Day" && toggle.isOn){
                
                p.hideEndTime(true)
                parent?.tableView.reloadData()
            }else if(title.text == "All-Day" && !toggle.isOn){
                p.hideEndTime(false)
            }
        }
        
    }

}
