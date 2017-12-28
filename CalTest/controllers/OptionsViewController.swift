//
//  OptionsViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 01/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FacebookLogin

class OptionsViewController: UIViewController {
   // var calendarVC: CalendarViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userFriends ])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .yellow
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
        print("======FACEBOOK LOGIN======")
        switch result {
        case LoginResult.success:
            print("Success")
            print(result)
            //TODO: handle new UID
            self.dismiss(animated: true, completion: ({() in
                self.calendarVC?.doLoad()
            }))
        default:
            print("fail")
        }
    }
    
}
