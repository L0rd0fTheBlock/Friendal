//
//  LoginViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 18/02/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit
//import FacebookCore
//import FacebookLogin
import UserNotifications
//import Crashlytics
import FirebaseUI

class LoginViewCell: UICollectionViewCell, FUIAuthDelegate {
    
    let imageView: UIImageView
    let title: UILabel
    let text: UILabel
    var parent: WelcomeViewController? = nil
    var authUI: FUIAuth
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 120))
        text = UILabel(frame: CGRect(x: 0, y: frame.height/4, width: frame.width, height: frame.height/2))
        
        authUI = FUIAuth.defaultAuthUI()!
        
        super.init(frame: frame)
        
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(authUI: authUI), FUIEmailAuth()
          //FUIFacebookAuth(),
         // FUITwitterAuth(),
         // FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()),
        ]
        authUI.providers = providers
        
        
        authUI.delegate = self
        
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 24)
        title.textAlignment = .center
        
        text.lineBreakMode = .byWordWrapping
        text.numberOfLines = 0
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 20)
        text.textAlignment = .center
        
        addSubview(imageView)
        addSubview(title)
        addSubview(text)
        
        let loginButton = UIButton(frame: CGRect(x: 100, y: 100, width: 300, height: 50))
        loginButton.backgroundColor = .blue
          loginButton.setTitle("Let's Get Started!", for: .normal)
          loginButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        loginButton.center = CGPoint(x: frame.width / 2, y: ((frame.height/4) * 3) + 50)
        addSubview(loginButton)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let authViewController = authUI.authViewController()
        parent?.present(authViewController  , animated: true, completion:  nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //MARK: Authentication Delegate
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
      // handle user and error as necessary
        if( error != nil){
            print("Error Logging In \(String(describing: error))")
        }else{
            let cal = CalendarHandler()
            cal.doesUserExist({(exists: Bool) in
                if(exists){
                    self.parent?.dismiss(animated: true, completion: nil)
                }else{
                    let manager = UserManagerViewController()
                    manager.shouldCreateUser = true
                    let nvc = CalendarNavigationController(rootViewController: manager)
                    self.parent?.present(nvc, animated: true, completion: nil)
            }
            })
        }
    }
}
