//
//  InviteFriendViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 24/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
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
        
        
       // let calHandler = CalendarHandler()
        
       /* calHandler.doGraph(request: "me", params: "id, first_name, last_name", completion: {(person, error) in
            
            guard let person = person else{
                return
            }
            
            self.me = Person(id: person["id"]as! String, first: person["first_name"] as! String, last: person["last_name"] as! String)
        })*/
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
        print(selected)
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
        print(selected)
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! FriendsListViewCell
        
       /* if(cell.uid == AccessToken.current?.userId){
            cell.name.text = cell.name.text! + " (You)"
        }
        */
        for invitee in invited{
            if(invitee.uid == cell.uid){
                cell.isUserInteractionEnabled = false
                cell.name.isEnabled = false
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
        
     //  let handler = CalendarHandler()
        
        for id in selected{
           // handler.saveNewRequest(event: (topView?.event?.id)!, user: id, name: (me?.name)!, isNotMe: true)
        }
        dismissView()
    }
}
