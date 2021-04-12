//
//  NewStatusViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 09/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class NewStatusViewCell: UICollectionViewCell, UITextViewDelegate {
    
   /* let status = UITextView()
    var event: Event? = nil
    let placeholder = UILabel(frame: .zero)
    let post = UIButton(type: .custom)
    
    let tutorialView = UIView(frame: .zero)
    
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
        
        if let tut = UserDefaults.standard.object(forKey: "didCloseStatusTutorial") as? Bool{
            if(!tut){
                setupTutorial()
            }
        }else{
            setupTutorial()
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPost(){
        let calHandler = CalendarHandler()
        guard let event = self.event else{
            print("No event found")
            return
        }
        print("posting")
        
       // calHandler.saveNewStatus(event: event.id, title: event.title!, sender: Settings.sharedInstance.uid, senderName: Settings.sharedInstance.me.name, message: status.text!) { (data) in
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
        
        
        information.text = "You can swipe from left to right to view Statuses"
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
    
    */
}
