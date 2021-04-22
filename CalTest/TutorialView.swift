//
//  TutorialView.swift
//  CalTest
//
//  Created by Jamie McAllister on 21/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class TutorialView: UIView {

    let information = UILabel()
    let close = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTutorial(withText: String){
        
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addSubview(self)
        topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        backgroundColor = UIColor(rgb: 0x01B30A, alpha: 0.8)
        
        information.translatesAutoresizingMaskIntoConstraints = false
        close.translatesAutoresizingMaskIntoConstraints = false
        
        // information.backgroundColor = .red
        //close.backgroundColor = .blue
        
        addSubview(information)
        addSubview(close)
        
        
        information.text = withText
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
        
        addGestureRecognizer(tapHandler)
        
    }
    
    @objc func didTapToClose(){
        print("tap")
        removeFromSuperview()
        UserDefaults.standard.set(true, forKey: "didCloseStatusTutorial")
    }

}
