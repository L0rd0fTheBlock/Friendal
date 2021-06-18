//
//  SettingsViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 03/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FirebaseAuth
//import FacebookLogin

class SettingsViewController: UITableViewController {
    var me:Person?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options"
        
        tableView.register(SettingsUserProfileCell.self, forCellReuseIdentifier: "user")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        tableView.register(SettingsToggleCell.self, forCellReuseIdentifier: "toggle")

        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let calHandler = CalendarHandler()
        
        calHandler.getperson(forUser: Auth.auth().currentUser!.uid, completion: {(p) in
            self.me = p
            self.tableView.reloadData()
        })
        
      //  calHandler.doGraph(request: "me", params: "id, first_name, last_name", completion: {(person, error) in
            
         /*   guard let person = person else{
                return
            }
            
            self.me = Person(id: person["id"]as! String, first: person["first_name"] as! String, last: person["last_name"] as! String)
            
            self.tableView.reloadData()
        })*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 2
        }else{
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "My Account"
        }else{
            return "Other settings"
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
        if(indexPath.section == 0){
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! SettingsUserProfileCell
                let profilePic = me?.picture
                cell.pic.image = profilePic
                cell.name.text = me?.name()
                
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
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                let manager = UserManagerViewController()
                if(me != nil){
                    manager.user = me!
                    let managerVC = CalendarNavigationController(rootViewController: manager)
                    
                    self.present(managerVC, animated: true, completion: ({() in
                        
                    }))
                }else{
                    do{
                      //  try Auth.auth().signOut()
                        
                    }catch{}
                   // navigationController?.pushViewController(WelcomeViewController(), animated: true)
                }
            }
        }
    }
}
