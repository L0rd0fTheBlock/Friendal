//
//  TabBarController.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 26/11/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
      //  hideKeyboardWhenTappedAround()
        
       // tabBar.barTintColor = .red//This in not going to work thanks to ios15 changes. Use tab bar appearance instead
       
        //tabBar.tintColor = UIColor.orange
        tabBar.unselectedItemTintColor = .white
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .nav
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        tabBar.standardAppearance = appearance;
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
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
