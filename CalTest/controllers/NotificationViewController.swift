//
//  NotificationViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 29/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class NotificationViewController: UITableViewController {

    let errorLabel = UILabel()
    var requests: [Request] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        
        
        
        tableView.register(NotificationRequestViewCell.self, forCellReuseIdentifier: "request")
        tableView.rowHeight = 150
        
    }
    
    func loadData(){
        requests.removeAll()
        errorLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height - 100)
        errorLabel.textAlignment = .center
        errorLabel.text = "Your notifications are loading."
        errorLabel.numberOfLines = 0
        errorLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(CGFloat(0.5))
        tableView.addSubview(errorLabel)
        
        let cal = CalendarHandler()
        requests = []
        cal.getRequests(forUser: (AccessToken.current?.userId)!, completion: { (request, error) in
            
            guard let r = request else{
                
                guard let code = error?.code else{return}
                
                self.errorLabel.text = error?.userInfo["message"] as! String + " Code: " + String(describing: code)
                self.errorLabel.isHidden = false
                self.tableView.reloadData()
                return
                
            }
            self.errorLabel.isHidden = true
            self.requests = r
            
            let calHandler = CalendarHandler()
            
            for request in self.requests{
                
                calHandler.doGraph(request: "/" + String(request.sender), params: "id, first_name, last_name, picture", completion: {(data, error)  in
                    
                    guard let p = data else{
                        return
                    }
                    
                    let picture = p["picture"]!
                    var pict = picture as! Dictionary<String, Any>
                    let pic = pict["data"] as! Dictionary<String, Any>
                    let person = Person(id: p["id"] as! String, first: p["first_name"] as! String, last: p["last_name"] as! String, picture: pic)
                    
                    request.person = person
                    
                    self.tabBarItem.badgeValue = String(self.requests.count)
                    person.downloadImage(url: URL(string: (person.link))!, table: self.tableView)
                    self.tableView.reloadData()
                })
            }
            
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
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
        
        if let sender = request.person?.name{
            
            if let event = request.event.title{
        
                cell.title.text = sender + " would like to arrange '" + event + "' with you"
                cell.title.sizeToFit()
            }
            cell.timeLabel.text = "on " + (request.event.date)! + "-" + (request.event.month)! + "-" + (request.event.year)! + " at: " + (request.event.start)!
        }
        cell.id = request.id
        cell.table = self
        cell.pic.image = request.person?.picture
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }


}
