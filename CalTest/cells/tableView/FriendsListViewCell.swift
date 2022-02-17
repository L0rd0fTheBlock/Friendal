//
//  FriendsListViewCell.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 27/11/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit

class FriendsListViewCell: UITableViewCell {

    let pic: UIImageView = UIImageView()
    let name: UILabel = UILabel()
    var uid:String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(name)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
