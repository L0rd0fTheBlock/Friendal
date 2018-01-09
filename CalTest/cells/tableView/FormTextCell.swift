//
//  FormTextCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 27/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

class FormTextCell: UITableViewCell {

    let desc = UILabel()
    let value = UITextField()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //desc.frame = CGRect(x: 10, y: 10, width: self.frame.width/3-20, height: self.frame.height)
        value.frame = CGRect(x: 20, y: 10, width: self.frame.width, height: self.frame.height)
       // self.addSubview(desc)
        self.addSubview(value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
