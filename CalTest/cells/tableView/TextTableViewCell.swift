//
//  TextTableViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 21/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    let title = UILabel(frame: .zero)
    let value = UILabel(frame: .zero)
    let chevron = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        value.frame = CGRect(x: frame.width - 30, y: 0, width: 30, height: frame.height)
        chevron.frame = CGRect(x: frame.width - 10, y: 0, width: 10, height: frame.height)
        addSubview(title)
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
