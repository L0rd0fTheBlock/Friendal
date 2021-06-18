//
//  FormDatePickerCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 27/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
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
        
        desc.frame = CGRect(x: 10, y: 10, width: self.frame.width/3, height: self.frame.height)
        
        //value.delegate = self
        value.frame = CGRect(x: self.frame.width/3, y: 10, width: (self.frame.width/3)*2, height: self.frame.height)
        contentView.addSubview(value)
        addSubview(desc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        
        if(showDate){
            datePicker.datePickerMode = .dateAndTime
        }else{
            datePicker.datePickerMode = .time
        }
        guard let startDate = startDate else{
            
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
            return
            
        }
        datePicker.date = startDate
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
    }
    
    @objc func pickerChanged(sender: UIDatePicker){
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
       formatter.dateStyle = .none
        if(desc.text == "Start"){
            formatter.dateStyle = .none
            start = formatter.string(from: sender.date)
        }else if(desc.text == "End"){
            end = formatter.string(from: sender.date)
        }
        
        
        if(showDate){
            formatter.dateStyle = .medium
        }
        /*value.date.description
        value.text = formatter.string(from: sender.date)
        if(showDate){
            formatter.dateStyle = .short
            shortDate = formatter.string(from: sender.date)
        }*/
        
    }

}
