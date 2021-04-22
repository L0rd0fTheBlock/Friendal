//
//  LoginViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 08/04/2021.
//  Copyright © 2021 Jamie McAllister. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FormTextCell.self, forCellReuseIdentifier: "text")
        
        self.title = "Login with Email"
        
        let buttonLeft = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancel) )
        
        navigationItem.setLeftBarButton(buttonLeft, animated: true)
        
        let buttonRight = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(didSave))
        
        navigationItem.setRightBarButton(buttonRight, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if(isLoggedIn()){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didSave(){}
    
    @objc func didCancel(){}
    
    func isLoggedIn() ->Bool {
        
        if(Auth.auth().currentUser != nil){
            print("User is Logged in")
            return true
        }else{
            return false
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.row {
        case 0://Spacing
            let cell:UITableViewCell = UITableViewCell()
            return cell
        case 1://Email
            let cell:FormTextCell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
            cell.value.placeholder = "Email"
            
            return cell
        case 2://Password
            let cell:FormTextCell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
                cell.value.placeholder = "Password"
                return cell
        default:
            print("error")
            return UITableViewCell()
        }
    }
    
}
