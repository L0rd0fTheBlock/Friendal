//
//  TextTableViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 21/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    let value = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(value)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
