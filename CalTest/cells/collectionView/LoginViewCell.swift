//
//  LoginViewCell.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 18/02/2018.
//  Copyright © 2018 MakeItForTheWeb Ltd.. All rights reserved.
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
        
        authUI = FUIAuth.defaultAuthUI()!
        
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(title)
        addSubview(text)
        
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(authUI: authUI), FUIEmailAuth()
          //FUIFacebookAuth(),
         // FUITwitterAuth(),
         // FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()),
        ]
        authUI.providers = providers
        
        
        authUI.delegate = self
        
        let loginButton = UIButton(frame: CGRect(x: 100, y: 100, width: 300, height: 50))
        loginButton.backgroundColor = .blue
          loginButton.setTitle("Let's Get Started!", for: .normal)
          loginButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        loginButton.center = CGPoint(x: frame.width / 2, y: ((frame.height/4) * 3) + 50)
        addSubview(loginButton)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let authViewController = authUI.authViewController()
        title.text = "We are aware of a bug preventing you from logging in"
        text.text = "We're working on it but in the mean time, please restart Palendar to continue"
        parent?.present(authViewController  , animated: true, completion:  nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //MARK: Authentication Delegate
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
      // handle user and error as necessary
        print("Login attempted")
        if( error != nil){
            print("Error Logging In \(String(describing: error))")
        }else{
            
            userHandler.doesUserExist({(exists: Bool) in
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
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
          print("Think did log in successful")
        return true
      }
      // other URL handling goes here.
        print("think did not log in")
      return false
    }
}
