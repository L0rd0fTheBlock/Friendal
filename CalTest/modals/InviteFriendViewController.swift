//
//  InviteFriendViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 24/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FirebaseAuth
//import FacebookCore

class InviteFriendViewController: FriendsListViewController {

    var topView: InviteesTableViewController? = nil
    
    var invited: [Person] = []
    
    var selected: [String] = []
    
    var me: Person? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
        
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(sendInvites))

        navigationItem.setLeftBarButton(done, animated: true)
        
        navigationItem.setRightBarButton(save, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selected = []
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FriendsListViewCell
        selected.append(cell.uid!)
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FriendsListViewCell
        
        for (index, person) in selected.enumerated(){
            if(person == cell.uid){
                selected.remove(at: index)
            }
        }
        if(selected.count == 0){
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! FriendsListViewCell
        
        if(cell.uid == Auth.auth().currentUser?.uid){
            cell.name.text = cell.name.text! + " (You)"
        }
        
        for invitee in invited{
            if(invitee.uid == cell.uid){
               // cell.isUserInteractionEnabled = false
                //cell.name.isEnabled = false
                #warning("These checks were disabled for debugging. Re-enable them")
            }
        }
        
        return cell
    }

    @objc
    func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func sendInvites(){
        
    
        let event = (topView?.event)! as Event
        for id in selected{
            inviteHandler.saveNewRequest(event: event.id, user: id, day: Int(event.date!)!, month: Int(event.month!)!, year: Int(event.year!)!){
                self.topView?.doLoad()
            }
        }
        dismissView()
        
        
    }
}
