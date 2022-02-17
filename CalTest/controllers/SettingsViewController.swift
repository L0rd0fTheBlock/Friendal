//
//  SettingsViewController.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 03/12/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit
import FirebaseAuth
//import FacebookLogin

class SettingsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options"
        
        tableView.register(SettingsUserProfileCell.self, forCellReuseIdentifier: "user")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        tableView.register(SettingsToggleCell.self, forCellReuseIdentifier: "toggle")
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "text")

        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        me.load { shouldLoad in
            
            if(shouldLoad){
                self.tableView.reloadData()
            }else{
                self.showLoginScreen()
            }
        }
        
        
    }

    func showLoginScreen(){
        let welcomeVC = WelcomeViewController()
        welcomeVC.modalPresentationStyle = .fullScreen
        navigationController?.present(welcomeVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "My Account"
        case 2:
            return "Bugs and Feature Requests"
        default:
            return "Error"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                return 100
            }else{
                return 50
            }
        }else{
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            return generateAccountSettingCells(indexPath)
        case 1:
            return generateDebugSettingCells(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.section{
        case 0:
            if(indexPath.row == 0){
                let manager = UserManagerViewController()
                    let managerVC = CalendarNavigationController(rootViewController: manager)
                    
                    self.present(managerVC, animated: true, completion: ({() in
                        
                    }))
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                //open link to Github bug reporting
                if let url = URL(string: "https://github.com/L0rd0fTheBlock/Palendar/issues") {
                    UIApplication.shared.open(url)
                }
            
            case 1:
                //open link to Discord server
                if let url = URL(string: "https://discord.gg/NHFrrUbZ") {
                    UIApplication.shared.open(url)
                }
            default:
                print("Error: DidSelectRowAt impossible IndexPath: S-0-R->1")
            }
        default:
            print("Error in Settings didSelectRowAt")
        }
        
        
        if(indexPath.section == 0){
            
        }
    }
    
    func generateAccountSettingCells(_ indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! SettingsUserProfileCell
            let profilePic = me.picture
            cell.pic.image = profilePic
            cell.name.text = "\(me.first_name) \(me.last_name)"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "toggle", for: indexPath) as! SettingsToggleCell
            
            cell.title.text = "Make New Events Private: "
            
            return cell
        case 2:
           let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func generateDebugSettingCells(_ indexPath: IndexPath) -> UITableViewCell{
        
        
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "text") as! TextTableViewCell
            cell.title.frame = CGRect(x: 30, y: cell.frame.height/5, width: cell.frame.width, height: cell.frame.height)
            cell.contentView.addSubview(cell.title)
            cell.title.text = "Report a bug or request a feature with Github"
            cell.title.textColor = .blue
            cell.value.isHidden = true
            cell.chevron.isHidden = true
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "text") as! TextTableViewCell
            cell.title.frame = CGRect(x: 30, y: cell.frame.height/5, width: cell.frame.width, height: cell.frame.height)
            cell.contentView.addSubview(cell.title)
            cell.title.text = "Join Palendar's Discord for a faster response"
            cell.title.textColor = .blue
            cell.value.isHidden = true
            cell.chevron.isHidden = true
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}
