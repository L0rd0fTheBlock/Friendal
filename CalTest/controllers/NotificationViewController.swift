//
//  NotificationViewController.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 29/11/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit
import FirebaseAuth
//import FacebookLogin
//import FacebookCore

class NotificationViewController: UITableViewController {

    let errorLabel = UILabel()
    var requests: [Request] = []
    var notificationAlert = NotificationResponseAlert()
    var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        tableView.register(NotificationRequestViewCell.self, forCellReuseIdentifier: "request")
        tableView.rowHeight = 150
        tableView.allowsSelection = true
        
        if(me.uid == ""){
            me.load { shouldLoad in
                
                if(shouldLoad){
                    self.doLoad()
                }else{
                    self.showLoginScreen()
                }
            }
        }
        
    }
    
    func showLoginScreen(){
        let welcomeVC = WelcomeViewController()
        welcomeVC.modalPresentationStyle = .fullScreen
        navigationController?.present(welcomeVC, animated: true, completion: nil)
    }
    
    @objc
    func willViewEvent(action: UIAlertAction){
        let r = requests[tableView.indexPathForSelectedRow!.row]
        let e = r.event
        let eventView = EventViewController()
        eventView.event = e
        eventView.isFromRequest = true
        eventView.requestId = r.id
        navigationController?.pushViewController(eventView, animated: true)
    }
    
    func doLoad(){
        requests.removeAll()
        tableView.reloadData()
        errorLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height - 100)
        errorLabel.textAlignment = .center
        errorLabel.text = "Your notifications are loading."
        errorLabel.numberOfLines = 0
        errorLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(CGFloat(0.5))
        tableView.addSubview(errorLabel)
        errorLabel.isHidden = false
        
        let inviteHandler = InviteHandler()
        inviteHandler.getRequests(forUser: Auth.auth().currentUser!.uid, completion: {(requests) in
            self.requests = requests
            self.tabBarItem.badgeValue = String(self.requests.count)
            self.tableView.reloadData()
            if(self.requests.count > 0){
                self.errorLabel.isHidden = true
            }else{
                self.errorLabel.text = "You have no Notifications."
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doLoad()
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
        return requests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request", for: indexPath) as! NotificationRequestViewCell
        
        let request = requests[indexPath.row]
        
        if let sender = request.person?.name(){
            
            if let event = request.event.title{
                cell.senderLabel.text = sender
                cell.descriptionLabel.text = "Would like you to attend: "
                cell.titleLabel.text = event
            }
            cell.timeLabel.text = "on " + request.event.getStartDay() + "-" + request.event.getStartMonth() + "-" + request.event.getStartYear() + " at: " + request.event.getStartTime()
        }
        cell.id = request.id
        cell.table = self
        cell.senderPic.image = request.person?.picture
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.isHighlighted = false
        let request =   requests[indexPath.row]
        notificationAlert = NotificationResponseAlert(forRequest: request.id, sender: self)
        alert = notificationAlert.alertWithView(willViewEvent)
        present(alert, animated: true, completion: {() in
            
        })
    }


}
