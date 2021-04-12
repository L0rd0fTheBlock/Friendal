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

class LoginViewCell: UICollectionViewCell {
    
    let imageView: UIImageView
    let title: UILabel
    let text: UILabel
    var parent: WelcomeViewController? = nil
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 120))
        text = UILabel(frame: CGRect(x: 0, y: frame.height/4, width: frame.width, height: frame.height/2))
        
        super.init(frame: frame)
        
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
          loginButton.setTitle("Login with Email", for: .normal)
          loginButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        loginButton.center = CGPoint(x: frame.width / 2, y: ((frame.height/4) * 3) + 50)
        addSubview(loginButton)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        let lgvc = LoginViewController()
        
        parent?.present(lgvc, animated: true, completion:  nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

/*extension LoginViewCell: LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
       print("didCompleteLogin")
        guard let p = parent else{
            print("crashing: ", "parent is null")
            let crash = Crashlytics()
            let error = NSError(domain: "uk.co.friendal", code: 003, userInfo: ["message": "The parent object returned null while guarding during login"])
            crash.recordError(error)
            return
        }
        
        if(p.isModal){
            print("isModal")
            switch result {
            case LoginResult.success:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(result, error) in
                    
                    let calHandler = CalendarHandler()
                    calHandler.registerDviceToken()
                    
                    p.dismiss(animated: true, completion: ({() in
                        
                        if(p.vc == "cal"){
                            let cal = p.calendarVC as! CalendarViewController
                            cal.doLoad()
                        }else if(p.vc == "friend"){
                            let cal = p.calendarVC as! FriendsListViewController
                            cal.doLoad()
                        }else{
                            print("crashing: ", p.vc)
                            let crash = Crashlytics()
                            let error = NSError(domain: "uk.co.friendal", code: 001, userInfo: ["message": "An Unidentified VC was used while logging in"])
                            crash.recordError(error)
                        }
                    }))
                    
                })
                //TODO: handle new UID
                
            default:
                print("fail")
            }
        }else{
            print("crashing: ", p.isModal)
            let crash = Crashlytics()
            let error = NSError(domain: "uk.co.friendal", code: 002, userInfo: ["message": "p.isModal returned false while logging in"])
            crash.recordError(error)
        }
        
    }

}*/
}
