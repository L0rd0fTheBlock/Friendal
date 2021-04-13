//
//  FriendsListViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 27/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
//import FacebookCore

class FriendsListViewController: UITableViewController {

    var friends: Array<Person> = []
    let errorLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
            tableView.delegate = self
            self.tableView.register(FriendsListViewCell.self, forCellReuseIdentifier: "friend")
            tableView.rowHeight = 90
        
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        
       /* if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            doLoad()
        }else{
            //Access Token does not exist
            let loginVC = LoginViewController()
            loginVC.calendarVC = self
            loginVC.vc = "friend"
            self.present(loginVC, animated: true, completion: ({() in
                
            }))
        }*/
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
        
        let calHandler = CalendarHandler()
        
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
    
    func populateFriends(data: Dictionary<String, Any>) -> Array<Person>{
        var people: Array<Person> = []
        let d = data["data"] as! Array<Dictionary<String, Any>>
        for person in d{
            
            let picture = person["picture"]!
            var pict = picture as! Dictionary<String, Any>
            let pic = pict["data"] as! Dictionary<String, Any>
 
            
            let friend = Person(id: person["id"] as! String, first: person["first_name"] as! String, last: person["last_name"] as! String, picture: pic)
            
            people.append(friend)
            
        }
        
       
        return people

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return friends.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let friendCal = CalendarViewController()
        friendCal.shouldLoadMyCalendar = false
        Settings.sharedInstance.selectedFriendId = friends[indexPath.row].uid
        
        navigationController?.pushViewController(friendCal, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FriendsListViewCell

        
      //  cell.backgroundColor = .red
        cell.pic.frame = CGRect(x: 20, y: 10, width: 70, height: 70)
        cell.name.frame = CGRect(x: 100, y: 10, width: cell.frame.width - 100, height: cell.frame.height - 20)
       // cell.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        
      cell.pic.image = friends[indexPath.row].picture
        cell.name.text = friends[indexPath.row].name
        cell.uid = friends[indexPath.row].uid
        cell.addSubview(cell.pic)
        cell.addSubview(cell.name)
        
        return cell
    }

}
