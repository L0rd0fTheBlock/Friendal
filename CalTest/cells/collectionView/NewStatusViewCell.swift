//
//  NewStatusViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 09/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class NewStatusViewCell: UICollectionViewCell, UITextViewDelegate {
    
    let status = UITextView()
    let placeholder = UILabel(frame: .zero)
    let post = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        status.frame = .zero
        
        status.translatesAutoresizingMaskIntoConstraints = false
        addSubview(status)
        status.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        status.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        status.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        status.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
        status.layer.borderWidth = 1.0
        status.layer.borderColor = UIColor.lightGray.cgColor
        
        
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholder)
        placeholder.text = "Say something..."
        
        placeholder.topAnchor.constraint(equalTo: status.topAnchor, constant: 5).isActive = true
        placeholder.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        placeholder.heightAnchor.constraint(equalToConstant: 20).isActive = true
        placeholder.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
        
        status.delegate = self
        
        post.frame = .zero
        post.translatesAutoresizingMaskIntoConstraints = false
        
        post.backgroundColor = UIColor(rgb: 0x01B30A)
        post.setTitleColor(.white, for: .normal)
        addSubview(post)
        
        post.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 5).isActive = true
        post.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        post.heightAnchor.constraint(equalToConstant: 40).isActive = true
        post.widthAnchor.constraint(equalToConstant: 75).isActive = true
        post.setTitle("Post", for: .normal)
        post.setTitle("Continue", for: .disabled)
        post.addTarget(self, action: #selector(didPost), for: .touchUpInside)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPost(){
        let calHandler = CalendarHandler()
        
        calHandler.saveNewStatus(event: (superview as! StatusView).eventID, sender: Settings.sharedInstance.uid, message: status.text!) { (data) in
            self.status.text = ""
            self.placeholder.isHidden = false
            (self.superview as! StatusView).doLoad()
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeholder.isHidden = true
        post.isEnabled = false
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        post.isEnabled = true
        return true
    }
    
    
}
