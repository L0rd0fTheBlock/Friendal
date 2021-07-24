//
//  TabBarController.swift
//  CalTest
//
//  Created by Jamie McAllister on 26/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

      //  hideKeyboardWhenTappedAround()
        
        tabBar.barTintColor = .nav
        //tabBar.tintColor = UIColor.orange
        tabBar.unselectedItemTintColor = UIColor(rgb:0xE3E3E3)
        
        let myMonth = CalendarNavigationController(rootViewController: CalendarViewController())
        myMonth.title = "My Month"
        myMonth.tabBarItem.image = UIImage(named: "icon_me")
        
        let friends = CalendarNavigationController(rootViewController: FriendsListViewController())
        friends.title = "Friends"
        friends.tabBarItem.image = UIImage(named: "icon_friends")
        
        let more = CalendarNavigationController(rootViewController: SettingsViewController())
       // let more = SettingsViewController()
        more.title = "Options"
        more.tabBarItem.image = UIImage(named: "hamburger")
        
        let notification = CalendarNavigationController(rootViewController: NotificationViewController())
        notification.title = "Notifications"
        notification.tabBarItem.image = UIImage(named: "icon_notification")
        
        viewControllers = [myMonth, friends, notification, more]
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
