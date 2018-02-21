//
//  SelectableTableViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 19/02/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class SelectableTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let st = UITableViewCellStyle.value1
        super.init(style: st, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
