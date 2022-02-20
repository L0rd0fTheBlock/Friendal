//
//  UserManagerViewController.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 03/05/2021.
//  Copyright © 2021 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserManagerViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var shouldCreateUser = false
    var requiredFieldsBlank = true
    var buttonLeft: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancel) )
    var buttonRight: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(didSave))
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(FormTextCell.self, forCellReuseIdentifier: "text")
        tableView.register(LogoutButtonCell.self, forCellReuseIdentifier: "logout")
        
        self.title = "Your Details"
        
        // buttonLeft = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancel) )
        
        navigationItem.setLeftBarButton(buttonLeft, animated: true)
        
       // buttonRight = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(didSave))
        
        navigationItem.setRightBarButton(buttonRight, animated: true)
        if(me.email == ""){
            me.email = (Auth.auth().currentUser?.email)!
        }
    }
    
    
    @objc func didSave(){
        
        setUserDetails()
        if(requiredFieldsBlank == true){
            let alert = UIAlertController(title: "Missing Required Fields", message: "All fields are required before continuing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Woops! I'll get right on that!", style: .default))
            self.present(alert, animated: true){
                return
            }
            
        }else{
            if(shouldCreateUser){
               userHandler.createUser(person: me)
                presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }else{
                userHandler.saveUser(person: me)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func didCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUserDetails(){
        //get Forename
        var cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! FormTextCell
        me.first_name = cell.value.text!
        if(me.first_name == "" || me.first_name == " "){
            requiredFieldsBlank = true
            return
        }else{
            requiredFieldsBlank = false
        }
        //get Surname
        cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FormTextCell
        me.last_name = cell.value.text!
        if(me.last_name == "" || me.last_name == " "){
            requiredFieldsBlank = true
            return
        }else{
            requiredFieldsBlank = false
        }
        //get email
        cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! FormTextCell
        me.email = cell.value.text!
        if(me.email == "" || me.email == " "){
            requiredFieldsBlank = true
            return
        }else{
            requiredFieldsBlank = false
        }
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
            
            pic.image = me.picture
            
            let overlay = UILabel()
            
            pic.addSubview(overlay)
            
            overlay.translatesAutoresizingMaskIntoConstraints = false
            
            overlay.centerYAnchor.constraint(equalTo: pic.centerYAnchor, constant: 75).isActive = true
            overlay.centerXAnchor.constraint(equalTo: pic.centerXAnchor).isActive = true
            //overlay.heightAnchor.constraint(equalTo: ).isActive = true
            overlay.widthAnchor.constraint(equalTo: pic.widthAnchor).isActive = true
            
            overlay.text = "Change Profile Pic"
            overlay.textAlignment = .center
            //overlay.backgroundColor = .lightGray
            //overlay.backgroundColor = overlay.backgroundColor?.withAlphaComponent(0.5)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
            
            cell.desc.text = "Forename: "
            cell.value.text = me.first_name
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
            
            cell.desc.text = "Surname: "
            cell.value.text = me.last_name
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! FormTextCell
            
            cell.desc.text = "Email: "
            cell.value.text = me.email
            
            
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
            me.picture = image
            tableView.reloadData()
        }
        
    }
}
