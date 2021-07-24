//
//  NewStatusViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 09/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewStatusViewCell: UICollectionViewCell, UITextViewDelegate {
    
    let status = UITextView()
    var event: Event? = nil
    let placeholder = UILabel(frame: .zero)
    let post = UIButton(type: .custom)
    
    let tutorialView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        status.frame = .zero
        
        status.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(status)
        status.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        status.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        status.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50).isActive = true
        status.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        
        status.layer.borderWidth = 1.0
        status.layer.borderColor = UIColor.lightGray.cgColor
        status.isEditable = true
        
        status.delegate = self
        
        status.text = "Say Something..."
        status.textColor = .lightGray
        
        status.font = UIFont(name: status.font!.fontName, size: 18)
        
        post.frame = .zero
        post.translatesAutoresizingMaskIntoConstraints = false
        
        post.backgroundColor = UIColor(rgb: 0x01B30A)
        post.setTitleColor(.white, for: .normal)
        contentView.addSubview(post)
        
        post.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 5).isActive = true
        post.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        post.heightAnchor.constraint(equalToConstant: 40).isActive = true
        post.widthAnchor.constraint(equalToConstant: 80).isActive = true
        post.setTitle("Post", for: .normal)
        post.setTitle("Continue", for: .disabled)
        post.addTarget(self, action: #selector(didPost), for: .touchUpInside)
        
        status.becomeFirstResponder()
        if let tut = UserDefaults.standard.object(forKey: "didCloseStatusTutorial") as? Bool{
            if(!tut){
                setupTutorial()
            }
        }else{
            setupTutorial()
        }
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPost(){
        guard let event = self.event else{
            return
        }
        
        statusHandler.submitStatus(forEvent: event.id, fromUser: Auth.auth().currentUser!.uid, withMessage: status.text, { () in
            (self.superview as! StatusView).doLoad()
        })
        self.status.text = ""
        self.setPlaceholder()
            
        }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        status.text = ""
        status.textColor = .black
        post.isEnabled = false
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        setPlaceholder()
        post.isEnabled = true
        return true
    }
    
    func setPlaceholder(){
        if(status.text.isEmpty){
            status.text = "Say Something..."
            status.textColor = .lightGray
        }
    }
    
    
    
    func setupTutorial(){
        
        tutorialView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tutorialView)
        
        tutorialView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tutorialView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tutorialView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tutorialView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        tutorialView.backgroundColor = UIColor(rgb: 0x01B30A, alpha: 0.8)
        
        let information = UILabel()
        let close = UILabel()
        
        information.translatesAutoresizingMaskIntoConstraints = false
        close.translatesAutoresizingMaskIntoConstraints = false
        
       // information.backgroundColor = .red
        //close.backgroundColor = .blue
        
        tutorialView.addSubview(information)
        tutorialView.addSubview(close)
        
        
        information.text = "You can swipe from Right to Left to view Statuses"
        information.numberOfLines = 0
        information.font = UIFont.systemFont(ofSize: 18)
        information.textColor = .white
        information.textAlignment = .center
        
        close.text = "Tap here to close"
        close.textAlignment = .center
        close.font = UIFont.boldSystemFont(ofSize: 14)
        close.textColor = .white
        
        close.heightAnchor.constraint(equalToConstant: 50).isActive = true
        close.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        close.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        close.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        information.topAnchor.constraint(equalTo: topAnchor).isActive = true
        information.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        information.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        information.bottomAnchor.constraint(equalTo: close.topAnchor).isActive = true
        
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(didTapToClose))
        
        tutorialView.addGestureRecognizer(tapHandler)
        
    }
    
    @objc func didTapToClose(){
        
        print("tap")
        tutorialView.removeFromSuperview()
        UserDefaults.standard.set(true, forKey: "didCloseStatusTutorial")
   }
}
