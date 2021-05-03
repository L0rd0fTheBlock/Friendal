//
//  UserManagerViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 03/05/2021.
//  Copyright © 2021 Jamie McAllister. All rights reserved.
//

import UIKit

class UserManagerViewController: UITableViewController{
    var user = Person()
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(FormTextCell.self, forCellReuseIdentifier: "text")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 220
        }else{
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            let pic = UIImageView(frame: .zero)
            pic.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(pic)
            
            pic.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            pic.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
            pic.widthAnchor.constraint(equalToConstant: 200).isActive = true
            pic.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            pic.image = user.picture
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
            
            cell.desc.text = "Forename: "
            cell.value.text = user.first_name
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
            
            cell.desc.text = "Surname: "
            cell.value.text = user.last_name
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
            
            cell.desc.text = "Email: "
            cell.value.text = user.email
            
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
            
            cell.desc.text = "Mobile: "
            cell.value.text = user.mobile
            
            
            return cell
            
        default:
            print("SOMETHING WENT WRONG=========================================================")
            return UITableViewCell()
        
        }
    }
}
