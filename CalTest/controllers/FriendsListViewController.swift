//
//  FriendsListViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 27/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

import Contacts
//import FacebookCore

class FriendsListViewController: UITableViewController {

    var friends: [Friend] = [Friend]()
    var requests: [Friend] = [Friend]()
    var selectedFriend = -1
    let errorLabel = UILabel()
    
    let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let requestMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Friends"
        
        tableView.delegate = self
        self.tableView.register(FriendsListViewCell.self, forCellReuseIdentifier: "friend")
        
        tableView.rowHeight = 90

        errorLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height - 100)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(CGFloat(0.5))
        
        tableView.addSubview(errorLabel)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let viewAction = UIAlertAction(title: "View", style: .default) { action in
            self.view()
        }
        
        let removeAction = UIAlertAction(title: "Remove Friend", style: .destructive) { action in
            self.removeFriend()
        }
        
        menu.addAction(viewAction)
        menu.addAction(removeAction)
        menu.addAction(cancelAction)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { action in
            friendHandler.acceptFriendRequest(withID: self.requests[self.selectedFriend].uid) {
                self.doLoad()
            }
        }
        
        let declineAction = UIAlertAction(title: "Decline", style: .destructive) { action in
            friendHandler.rejectFriendRequest(withID: self.requests[self.selectedFriend].uid) {
                self.doLoad()
            }
        }
        
        requestMenu.addAction(acceptAction)
        requestMenu.addAction(declineAction)
        requestMenu.addAction(cancelAction)
        
       
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddFriend))
        
        navigationItem.setRightBarButton(button, animated: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        friends.removeAll()
        me.load { shouldLoad in
            
            if(shouldLoad){
                self.doLoad()
            }else{
                self.showLoginScreen()
            }
        }
        doLoad()
    }
    
    func showLoginScreen(){
        let welcomeVC = WelcomeViewController()
        welcomeVC.modalPresentationStyle = .fullScreen
        navigationController?.present(welcomeVC, animated: true, completion: nil)
    }
    
    
    @objc func didTapAddFriend(){
        let finder = FriendFinder()
        finder.present(sender: self)
    }
    
    func doLoad(){
        friends.removeAll()
        tableView.reloadData()
        
        errorLabel.text = "Your Friends List is loading."
        errorLabel.isHidden = false
        
        friendHandler.getFriendsList { friendList in
            self.friends = friendList.sorted(by: { person1, person2 in
                let personName1 = person1.last_name + person1.first_name
                let personName2 = person2.last_name + person2.first_name
                return personName1.localizedCaseInsensitiveCompare(personName2) == .orderedAscending
            })
            
            self.tableView.reloadData()
            if(self.friends.count>0){
                self.errorLabel.isHidden = true
            }else{
                self.errorLabel.text = "You do not have any Friends on Palendar Yet"
                self.errorLabel.isHidden = false
            }
        }
        
        friendHandler.getFriendRequests { requests in
            print(requests.count)
            self.requests = requests.sorted(by: { person1, person2 in
                let personName1 = person1.last_name + person1.first_name
                let personName2 = person2.last_name + person2.first_name
                return personName1.localizedCaseInsensitiveCompare(personName2) == .orderedAscending
            })
            print(self.requests.count)
            self.tableView.reloadData()
        }

        
    }
    
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
        switch section{
        case 1:
            return friends.count
        case 2:
            return requests.count
        default:
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 1:
            selectedFriend = indexPath.row
            present(menu, animated: true) {
                
            }
            Settings.sharedInstance.selectedFriendId = friends[indexPath.row].uid
            break
        case 2:
            selectedFriend = indexPath.row
            present(requestMenu, animated: true) {
                
            }
            break
        default:
            break
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
           // let cell = UITableViewCell()
           // var text =
            return UITableViewCell()
        }
        if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FriendsListViewCell

            
          //  cell.backgroundColor = .red
            cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
            cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
           // cell.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
            
          cell.pic.image = friends[indexPath.row].picture
            cell.name.text = friends[indexPath.row].name()
            cell.uid = friends[indexPath.row].uid
            cell.addSubview(cell.pic)
            cell.addSubview(cell.name)
            
            return cell
        }else{
            print("Creating cell for request")
                let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FriendsListViewCell

                
              //  cell.backgroundColor = .red
                cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
                cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
               // cell.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
                
              cell.pic.image = requests[indexPath.row].picture
                cell.name.text = requests[indexPath.row].name()
                cell.uid = requests[indexPath.row].uid
                cell.addSubview(cell.pic)
                cell.addSubview(cell.name)
                
                return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section{
        case 0:
            return "Your Friend Code is: \(me.friendCode)"
        case 1:
            return "Friends"
        default:
            return "Friend Requests"
        }
    }
    
    //MARK: Menu Actions
    
    func view(){
        let friendCal = CalendarViewController()
        friendCal.shouldLoadMyCalendar = false
        
        navigationController?.pushViewController(friendCal, animated: true)
    }
    
    func removeFriend(){
        
        let friendshipID = friends[selectedFriend].friendshipID
        
        friendHandler.removeFriend(withId: friendshipID) {
            self.doLoad()
        }
    }
    
}

