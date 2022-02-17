//
//  CalendarNavigationController.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 02/12/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit

class CalendarNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationBar.barTintColor = .nav
        navigationBar.tintColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .nav
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if(self.viewControllers.count == 1){
            if(type(of: viewController) == type(of: CalendarViewController())){
                viewController.hidesBottomBarWhenPushed = false
            }else{
                viewController.hidesBottomBarWhenPushed = true
            }
        }else{
            viewController.hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
    }

}


