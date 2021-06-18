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
    var shouldDisplayDescription = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        desc.translatesAutoresizingMaskIntoConstraints = false
        value.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(desc)
        contentView.addSubview(value)
        
        setConstraints()
    }
    
    
    func setConstraints(){
        
        if(shouldDisplayDescription){
            //Description Constraints
            
            desc.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
            desc.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
            desc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
            desc.rightAnchor.constraint(equalTo: desc.leftAnchor, constant: 100).isActive = true
            
            //Value Constraints
            value.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
            value.leftAnchor.constraint(equalTo: desc.rightAnchor, constant: 10).isActive = true
            value.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
            value.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        }
        
        
    }
    
    
    
    func displayDescription(_ v: Bool){
        if(v == false){
            shouldDisplayDescription = false
            let index = contentView.subviews.firstIndex(of: desc)
            desc.removeFromSuperview()
            setConstraints()
        }else{
            shouldDisplayDescription = true
            contentView.addSubview(desc)
            setConstraints()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
