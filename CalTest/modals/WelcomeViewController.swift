//
//  LoginViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 25/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import UserNotifications
//import FacebookLogin
//import FacebookCore
//import FBSDKLoginKit

class WelcomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var isModal = true
    
    var vc: String? = nil
    
    var calendarVC: UIViewController? = nil
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.bounces = false
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Options"
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        
        collectionView.register(LoginViewCell.self, forCellWithReuseIdentifier: "cell")
        
        
        view.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(rgb: 0x01B30A)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LoginViewCell
        
        cell.parent = self
        
        if(indexPath.item == 0){
            
            cell.imageView.image = UIImage(named: "friends2")
            cell.title.text = "Connect with your friends like never before."
            cell.text.text = "Friendal let's you see when your Facebook friends are free"
            return cell
        }else if(indexPath.item == 1){
            cell.imageView.image = UIImage(named: "sunset")
            cell.title.text = "Invite groups of friends to events"
            cell.text.text = "Invite large groups of friends to join you at important events"
            return cell
        }else{
            cell.imageView.image = UIImage(named: "night out")
            cell.title.text = "Planning that important night out has never been easier"
            cell.text.text = ""
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}


