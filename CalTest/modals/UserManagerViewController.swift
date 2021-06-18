//
//  UserManagerViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 03/05/2021.
//  Copyright © 2021 Jamie McAllister. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserManagerViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var user = Person()
    var shouldCreateUser = false
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(FormTextCell.self, forCellReuseIdentifier: "text")
        tableView.register(LogoutButtonCell.self, forCellReuseIdentifier: "logout")
        
        self.title = "Your Details"
        
        let buttonLeft = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancel) )
        
        navigationItem.setLeftBarButton(buttonLeft, animated: true)
        
        let buttonRight = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(didSave))
        
        navigationItem.setRightBarButton(buttonRight, animated: true)
        if(user.email == ""){
            user.email = (Auth.auth().currentUser?.email)!
        }
    }
    
    
    @objc func didSave(){
        
        setUserDetails()
        let cal = CalendarHandler()
        if(shouldCreateUser){
           cal.createUser(person: user)
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }else{
            cal.saveUser(person: user)
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @objc func didCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUserDetails(){
        //get Forename
        var cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! FormTextCell
        user.first_name = cell.value.text!
        
        //get Surname
        cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FormTextCell
        user.last_name = cell.value.text!
        
        //get email
        cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! FormTextCell
        user.email = cell.value.text!
        
        //get mobile
        cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! FormTextCell
        user.mobile = cell.value.text!
    }
    
    
    @objc func doLogout(){
        do {
            try  Auth.auth().signOut()
            self.dismiss(animated: true) {
                if let tab = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? UITabBarController {
                    tab.selectedIndex = 0
                }
            }
        } catch {
            
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
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
        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath) as! LogoutButtonCell
            
            cell.button.setTitle("Logout", for: .normal)
            cell.button.addTarget(self, action: #selector(doLogout), for: .touchUpInside)
            cell.button.backgroundColor = .systemRed
            
            return cell
            
        default:
            return UITableViewCell()
        
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            
            let ip = UIImagePickerController()
            ip.sourceType = .photoLibrary
            ip.allowsEditing = true
            ip.delegate = self
            
            ip.mediaTypes = ["public.image"]
            
            present(ip, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        var image = info[.editedImage] as? UIImage
        
        if(image == nil){
            image = info[.originalImage] as? UIImage
        }
        
        if(image == nil){
            print("Error Retrieving Image")
        }else{
            user.picture = image
            tableView.reloadData()
        }
        
    }
}
