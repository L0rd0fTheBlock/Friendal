//
//  LoginViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 25/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import UserNotifications
import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class LoginViewController: UIViewController {

    var isModal = true
    
    var vc: String? = nil
    
    var calendarVC: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Options"
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userFriends ])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(rgb: 0x01B30A)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        if(isModal){
            
            switch result {
            case LoginResult.success:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(result, error) in
                    
                    self.dismiss(animated: true, completion: ({() in
                        
                        if(self.vc == "cal"){
                            let cal = self.calendarVC as! CalendarViewController
                            cal.doLoad()
                        }else if(self.vc == "friend"){
                            let cal = self.calendarVC as! FriendsListViewController
                            cal.doLoad()
                        }
                    }))
                    
                })
                //TODO: handle new UID
                
            default:
                print("fail")
            }
        }
        
    }
    
}
