//
//  FormDatePickerCell.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 27/11/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit

class FormDatePickerCell: UITableViewCell, UITextFieldDelegate {

    var showDate: Bool = true
    let desc = UILabel()
    let value = UIDatePicker()
    var shortDate: String?
    var start: String?
    var end: String?
    var startDate:Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(value)
        contentView.addSubview(desc)
        setLayoutConstraints()
    }
    
    func setLayoutConstraints(){
        
        //set Desc Layout Constraints
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        desc.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        desc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        
        //set Value Layout Constraints
        value.translatesAutoresizingMaskIntoConstraints = false
        value.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        value.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        value.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
