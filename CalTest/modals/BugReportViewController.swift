//
//  BugReportViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 01/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class BugReportViewController: UIViewController {

    let web = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bug Report"
        
        web.frame = view.frame
        let git = URLRequest(url: URL(string: "https://github.com/jamiemac262/Friendal/issues")!)
        
        web.loadRequest(git)
        
        view.addSubview(web)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(isDone))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func isDone(){
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
