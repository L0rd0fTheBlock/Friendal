//
//  InviteesTableViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 22/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FirebaseAuth
//import FacebookCore
class InviteesTableViewController: UITableViewController, UIContextMenuInteractionDelegate {
    var event:Event? = nil
    var count = 0
    var going:[Person] = []
    var notGoing: [Person] = []
    var invited: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FriendsListViewCell.self, forCellReuseIdentifier: "Friend")
        tableView.rowHeight = 90
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //reinitialise the arrays
        
        going = []
        notGoing = []
        invited = []
        
        //get all invitees for an event
        getInvited()
        if(!(event?.canInvite)!){
            //if the event does not allow invites
            if(event?.creator == Auth.auth().currentUser?.uid){
                //if the user is the event creator create the add button
                let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(beginInvites))
                
                navigationItem.setRightBarButton(add, animated: true)
            }
        }else{
            //if inviting is allowed create the add button
            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(beginInvites))
            
            navigationItem.setRightBarButton(add, animated: true)
        }
        
        
    }
    
    func getInvited(){
        
        let inviteHandler = InviteHandler()
        
        inviteHandler.getRequests(forEvent: event!.id, completion: {(g, ng, inv) in
            
            self.going = g
            self.notGoing = ng
            self.invited = inv
            self.tableView.reloadData()
            
        })
       
    }//end function
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeInvite(atIndexPath: IndexPath){
        let inviteHandler = InviteHandler()
        let sec = atIndexPath.section
        let index = atIndexPath.row
        
        
        switch sec{
        
        case 0:
            inviteHandler.removeRequest(foruser: going[index].uid, fromEvent: event!.id)
            going.remove(at: index)
            tableView.reloadData()
            break
        case 1:
            inviteHandler.removeRequest(foruser: notGoing[index].uid, fromEvent: event!.id)
            notGoing.remove(at: index)
            tableView.reloadData()
            break
        default:
            inviteHandler.removeRequest(foruser: invited[index].uid, fromEvent: event!.id)
            invited.remove(at: index)
            tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return going.count
        case 1:
            return notGoing.count
        case 2:
            return invited.count
        default:
            print("Error: too many sections at: numberOfRowsInSection")
            return 0
        }
        //return going.count
    }
    
   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Going"
        case 1:
            return "Not Going"
        case 2:
            return "Invited"
        default:
            print("Too Many Sections in: titleForHeaderInSection")
            return "Excess Header"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            return populateGoing(indexPath)
        case 1:
            return populateNotGoing(indexPath)
        case 2:
            return populateInvited(indexPath)
        default:
            print("Defaulting cellForRowAt: Extra Sections in invitees Controller")
            return UITableViewCell()
        }
    }
    
    
    func populateGoing(_ index: IndexPath) -> UITableViewCell{
        
        let _ = UIContextMenuInteraction(delegate: self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: index) as! FriendsListViewCell
        
        let person = going[index.row]
        cell.name.text = person.name()
        cell.pic.image = person.picture!
        cell.uid = person.uid
        
        cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
        cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
        
        cell.addSubview(cell.name)
        cell.addSubview(cell.pic)
        
       // cell.addInteraction(interaction)
        
        if(cell.uid == Auth.auth().currentUser?.uid){
            cell.name.text = cell.name.text! + " (You)"
        }
        
        return cell
    }
    
    func populateNotGoing(_ index: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: index) as! FriendsListViewCell
        
        let person = notGoing[index.row]
        cell.name.text = person.name()
        cell.pic.image = person.picture!
        cell.uid = person.uid
        
        cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
        cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
        
        cell.addSubview(cell.name)
        cell.addSubview(cell.pic)
        
        if(cell.uid == Auth.auth().currentUser?.uid){
            cell.name.text = cell.name.text! + " (You)"
        }
        
        return cell
    }
    
    func populateInvited(_ index: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: index) as! FriendsListViewCell
        
        let person = invited[index.row]
        cell.name.text = person.name()
        cell.pic.image = person.picture!
        cell.uid = person.uid
        cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
        cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
        
        cell.addSubview(cell.name)
        cell.addSubview(cell.pic)
        
       if(cell.uid == Auth.auth().currentUser?.uid){
        cell.name.text = cell.name.text! + " (You)"
    }
        
        return cell
    }

    @objc
    func beginInvites(){
        
        let inviteVC = InviteFriendViewController()
        inviteVC.title = "Invite Friends"
        inviteVC.topView = self
        inviteVC.invited = going
        inviteVC.invited.append(contentsOf: notGoing)
        inviteVC.invited.append(contentsOf: invited)
        let navItem = CalendarNavigationController(rootViewController: inviteVC)
        navigationController?.present(navItem, animated: true, completion: nil)
        
    }
    
    //MARK: context Delegate
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration()
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                suggestedActions in
            let deleteAction =
                UIAction(title: NSLocalizedString("Uninvite", comment: "Delete this user's invite"),
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive) { action in
                    self.removeInvite(atIndexPath: indexPath)
                }
            return UIMenu(title: "", children: [deleteAction])
        })
    }
}
