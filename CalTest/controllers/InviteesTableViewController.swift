//
//  InviteesTableViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 22/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FacebookCore
class InviteesTableViewController: UITableViewController {

    var event:Event? = nil
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
        getGoing()
        getNotGoing()
        getInvited()
        if(!(event?.canInvite)!){
            if(event?.creator == AccessToken.current?.userId){
                let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(beginInvites))
                
                navigationItem.setRightBarButton(add, animated: true)
            }
        }else{
            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(beginInvites))
            
            navigationItem.setRightBarButton(add, animated: true)
        }
    }
    
    
    func getGoing(){
        
        let calHandler = CalendarHandler()
        
        calHandler.getGoing(forEvent: (event?.id)!, completion: {(invitees, error) in
           
            print("======GOING======")
            print(invitees)
            guard let invite = invitees else{return}
            for invitee in invite{
                
                calHandler.doGraph(request: invitee.UID, params: "id, first_name, last_name, middle_name, name, email, picture", completion: {(data, error) in
                    
                    guard let data  = data else{return}
                    
                    let pic = data["picture"] as! Dictionary<String, Any>
                    
                    let person = Person(id: data["id"] as! String, first: data["first_name"] as! String, last: data["last_name"] as! String, picture: pic["data"] as! Dictionary<String, Any>)
                    
                    self.going.append(person)
                    
                    
                    
                        person.downloadImage(url: URL(string: person.link)!, table: self.tableView)
                    
                    self.tableView.reloadData()
                    
                })//end graph
                
            }//end invitees loop
            self.tableView.reloadData()
        })//end getGoing
    }//end function
    
    func getNotGoing(){
        
        let calHandler = CalendarHandler()
        
        calHandler.getNotGoing(forEvent: (event?.id)!, completion: {(invitees, error) in
            
            print("======NOT GOING======")
            print(invitees)
            
            guard let invite = invitees else{return}
            
            for invitee in invite{
                
                calHandler.doGraph(request: invitee.UID, params: "id, first_name, last_name, middle_name, name, email, picture", completion: {(data, error) in
                    
                    guard let data = data else{return}
                    
                    let pic = data["picture"] as! Dictionary<String, Any>
                    
                    let person = Person(id: data["id"] as! String, first: data["first_name"] as! String, last: data["last_name"] as! String, picture: pic["data"] as! Dictionary<String, Any>)
                    
                    self.notGoing.append(person)
                    
                    
                    
                    person.downloadImage(url: URL(string: person.link)!, table: self.tableView)
                    
                    self.tableView.reloadData()
                    
                })//end graph
                
            }//end invitees loop
            self.tableView.reloadData()
        })//end getNotGoing
    }//end function
    
    func getInvited(){
        
        let calHandler = CalendarHandler()
        
        calHandler.getInvited(forEvent: (event?.id)!, completion: {(invitees, error) in
            print("======Invited======")
            print(invitees)
            
            guard let invite = invitees else{return}
            
            for invitee in invite{
                
                calHandler.doGraph(request: invitee.UID, params: "id, first_name, last_name, middle_name, name, email, picture", completion: {(data, error) in
                    
                    guard let data = data else{return}
                    
                    let pic = data["picture"] as! Dictionary<String, Any>
                    
                    let person = Person(id: data["id"] as! String, first: data["first_name"] as! String, last: data["last_name"] as! String, picture: pic["data"] as! Dictionary<String, Any>)
                    
                    self.invited.append(person)
                    
                    
                    
                    person.downloadImage(url: URL(string: person.link)!, table: self.tableView)
                    
                    self.tableView.reloadData()
                    
                })//end graph
                
            }//end invitees loop
            self.tableView.reloadData()
        })//end getInvited
    }//end function
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: index) as! FriendsListViewCell
        
        let person = going[index.row]
        cell.name.text = person.name
        cell.pic.image = person.picture
        cell.uid = person.uid
        
        cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
        cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
        
        cell.addSubview(cell.name)
        cell.addSubview(cell.pic)
        
        if(cell.uid == AccessToken.current?.userId){
            cell.name.text = cell.name.text! + " (You)"
        }
        
        return cell
    }
    
    func populateNotGoing(_ index: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: index) as! FriendsListViewCell
        
        let person = notGoing[index.row]
        cell.name.text = person.name
        cell.pic.image = person.picture
        cell.uid = person.uid
        
        cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
        cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
        
        cell.addSubview(cell.name)
        cell.addSubview(cell.pic)
        
        if(cell.uid == AccessToken.current?.userId){
            cell.name.text = cell.name.text! + " (You)"
        }
        
        return cell
    }
    
    func populateInvited(_ index: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: index) as! FriendsListViewCell
        
        let person = invited[index.row]
        cell.name.text = person.name
        cell.pic.image = person.picture
        cell.uid = person.uid
        cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
        cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
        
        cell.addSubview(cell.name)
        cell.addSubview(cell.pic)
        
        if(cell.uid == AccessToken.current?.userId){
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

}
