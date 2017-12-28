//
//  SettingsViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 03/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FacebookLogin

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath)

        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userFriends ])
        loginButton.center = cell.center
        loginButton.delegate = self
        cell.addSubview(loginButton)

        return cell
    }



}

extension SettingsViewController: LoginButtonDelegate{
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("well... this is akward... it appears you have found a bug in me.")
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        tabBarController?.selectedIndex = 0
    }
    
    
}
