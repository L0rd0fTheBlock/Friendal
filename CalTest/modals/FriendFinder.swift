//
//  FriendFinder.swift
//  CalTest
//
//  Created by Andrew McAllister on 20/07/2021.
//  Copyright © 2021 MakeItForTheWeb Ltd. All rights reserved.
//

import UIKit

class FriendFinder{
    
    var isTestMode = false
    
    var sender: FriendsListViewController?
    
    var person = Person()
    
    let friendView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let profilePic = UIImageView()
    let nameLabel = UILabel()
    
    
    let searchView = UIAlertController(title: "Find a Friend", message: "Enter a Friend Code", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    private var searchAction = UIAlertAction()
    private var add = UIAlertAction()
    init(){
        
        searchView.addTextField { text in
        }
        
        setActions()
        buildFriendView()
    }
    
    
    func buildFriendView(){
        
        let profile = UIView()
        friendView.view.addSubview(profile)
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.topAnchor.constraint(equalTo: friendView.view.topAnchor, constant: 45).isActive = true
        profile.rightAnchor.constraint(equalTo: friendView.view.rightAnchor, constant: -10).isActive = true
        profile.leftAnchor.constraint(equalTo: friendView.view.leftAnchor, constant: 10).isActive = true
        profile.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        friendView.view.translatesAutoresizingMaskIntoConstraints = false
        friendView.view.heightAnchor.constraint(equalToConstant: 330).isActive = true
    
        profile.addSubview(profilePic)
        profile.addSubview(nameLabel)
        
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        
        profilePic.centerYAnchor.constraint(equalTo: profile.topAnchor).isActive = true
        profilePic.centerXAnchor.constraint(equalTo: profile.centerXAnchor).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: profile.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: profile.widthAnchor, constant: -20).isActive = true
        
        nameLabel.textAlignment = .center
        nameLabel.text = "Testing Name"
        
        profilePic.image = UIImage(named: "default_profile")

    }
    
    func setActions(){
        searchAction = UIAlertAction(title: "Search", style: .default, handler: doSearch)
        
        searchView.addAction(searchAction)
        searchView.addAction(cancelAction)
        
        friendView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
         add = UIAlertAction(title: "Add Friend", style: .default){ action in
            friendHandler.addFriend(withID: self.person.uid){
                self.sender?.doLoad()
            }
        }
        
        friendView.addAction(add)
        
    }
    
    func present(sender: FriendsListViewController){
        self.sender = sender
        sender.present(searchView, animated: true) {
            
        }
        
    }
    
    @objc func doSearch(action: UIAlertAction){
        let field = searchView.textFields![0]
        userHandler.getperson(withCode: field.text!) { p, r in
            if(r){//code returned a user
                self.person = p
                self.nameLabel.text = self.person.name()
                self.profilePic.image = self.person.picture
                if(p.uid == me.uid && self.isTestMode == false){
                    self.add.isEnabled = false
                }
                self.sender?.present(self.friendView, animated: true, completion: {
                    
                })
                
            }
        }
    }
}
