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

    var friends: Array<Person> = []
    var contacts: Array<Person> = []
    let errorLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Friends"
        
        tableView.delegate = self
        self.tableView.register(FriendsListViewCell.self, forCellReuseIdentifier: "friend")
        tableView.rowHeight = 90

        
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        friends.removeAll()
        if Auth.auth().currentUser != nil {
            // User is logged in, use 'accessToken' here.
            doLoad()
        }else{
            //Access Token does not exist
            #warning("Implement User checks here")
        }
    }
    
    func doLoad(){
        friends.removeAll()
        tableView.reloadData()
        errorLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height - 100)
        errorLabel.textAlignment = .center
        errorLabel.text = "Your Friends List is loading."
        errorLabel.numberOfLines = 0
        errorLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(CGFloat(0.5))
        errorLabel.isHidden = false
        tableView.addSubview(errorLabel)
        
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
            }
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return friends.count
        }else{
            return contacts.count
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let friendCal = CalendarViewController()
        friendCal.shouldLoadMyCalendar = false
        Settings.sharedInstance.selectedFriendId = friends[indexPath.row].uid
        
        navigationController?.pushViewController(friendCal, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FriendsListViewCell

            
          //  cell.backgroundColor = .red
            cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
            cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
           // cell.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
            
          cell.pic.image = contacts[indexPath.row].picture
            cell.name.text = contacts[indexPath.row].name()
            cell.uid = contacts[indexPath.row].uid
            cell.addSubview(cell.pic)
            cell.addSubview(cell.name)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Friends"
        }else{
            return "These contacts are not on Palendar"
        }
    }
    
    
    //MARK: DEPRECATED CODE
    /*  calHandler.doGraph(request: "me/friends", params: "id, first_name, last_name, middle_name, name, email, picture", completion: {(data, error) in
          
          guard let friends = data else{
              guard let code = error?.code else{return}
              
              self.errorLabel.text = error?.userInfo["message"] as! String + " Code: " + String(describing: code)
              self.errorLabel.isHidden = false
              self.tableView.reloadData()
              return
              
          }
          if(friends.count > 0){
          self.errorLabel.isHidden = true
          //if(data[0] != nil){
          self.friends = self.populateFriends(data: friends)
          
          
          for person in self.friends{
              person.downloadImage(url: URL(string: person.link)!, table: self.tableView)
          }
          
          self.tableView.reloadData()
          //}
          }else{
              self.errorLabel.text = "None of your friends have installed Friendal yet"
              self.errorLabel.isHidden = false
              self.tableView.reloadData()
          }
      })*/
    

}

