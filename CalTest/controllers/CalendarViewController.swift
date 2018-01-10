//
//  ViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 19/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore


class CalendarViewController: UIViewController, UIGestureRecognizerDelegate {
    var dates: Array<CalendarDay> = []
    let cellId = "day"
    var selectedCell: Int = -1
    let errorLabel = UILabel()
    
    
    var shouldLoadUserCalendar: Bool = true
    var nonUserUID: String? = nil
    
    var month: Int = 0//the selected month
    var year:  Int = 0//the selected year
    var diff:  Int = 0//month difference
    var yDiff: Int = 0//year difference
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       // navigationController.
        
        
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapNewEventButton))
        
        navigationItem.setRightBarButton(button, animated: true)
        
        
        let recognizerRight = UISwipeGestureRecognizer(target: self, action:#selector(handleSwipe(swipe:)))
        
        recognizerRight.delegate = self
        view.addGestureRecognizer(recognizerRight)
        
        let recognizerLeft = UISwipeGestureRecognizer(target: self, action:#selector(handleSwipe(swipe:)))
        recognizerLeft.delegate = self
        recognizerLeft.direction = .left
        view.addGestureRecognizer(recognizerLeft)
        
        view.isUserInteractionEnabled = true
        
        
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            doLoad()
            //UNCOMMENT THESE LINES FOR DEBUG
            /*let loginVC = LoginViewController()
             loginVC.calendarVC = self
             self.present(loginVC, animated: true, completion: ({() in
             
             }))*/
        }else{
            if(!shouldLoadUserCalendar){
                AppEventsLogger.log("Viewed Friend Calendar")
            }else{
                AppEventsLogger.log("viewed Own Calendar")
            }
            //Access Token does not exist
            let loginVC = LoginViewController()
            loginVC.calendarVC = self
            loginVC.vc = "cal"
            self.present(loginVC, animated: true, completion: ({() in
                
            }))
        }
    }
    

    func setupCalendar(){
        
        view.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: view.frame.height)
        
    }
    
    func doLoad(){
        dates.removeAll()
        errorLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height - 100)
        errorLabel.textAlignment = .center
        errorLabel.text = "The calendar is loading."
        errorLabel.numberOfLines = 0
        errorLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(CGFloat(0.5))
        
        collectionView.addSubview(errorLabel)
        
        Settings.sharedInstance.load()
        
        let cal = CalendarHandler()
        
        
        let date = Date()
        let calendar = Calendar.current
        month = calendar.component(.month, from: date)
        year = calendar.component(.year, from: date)
        var user: String = (AccessToken.current?.userId)!
        if(!shouldLoadUserCalendar){
            user = nonUserUID!
        }
        
        cal.getCalMonth(forMonth: String(month), ofYear: String(year), withUser: user, completion: { (data, m, error) in
            
            guard let events = data, let month = m  else{
                print(error)
                guard let code = error?.code else{return}
                self.errorLabel.isHidden = false
                self.errorLabel.text = (error?.userInfo["message"] as? String)! + " Code: " + String(describing: code)
                self.collectionView.reloadData()
                return
            }
            self.errorLabel.isHidden = true
            self.dates = events
            self.navigationItem.title = month + " " + String(self.year)
            self.collectionView.reloadData()
        })
        setupCalendar()
        collectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    @objc func didTapNewEventButton(){
        
        if(shouldLoadUserCalendar){
        
            let addVC = CalendarNavigationController(rootViewController: NewEventVC())
            let vc:NewEventVC = addVC.topViewController as! NewEventVC
        
            vc.calendarVC = self
        
            self.present(addVC, animated: true, completion: ({() in
                
            }))
        }else{
            let addVC = CalendarNavigationController(rootViewController: NewRequestVC())
            
            let vc:NewRequestVC = addVC.topViewController as! NewRequestVC
            
            vc.calendarVC = self
            
            self.present(addVC, animated: true, completion: ({() in
                
            }))
            
        }
    }
    
    @objc func handleSwipe(swipe: UISwipeGestureRecognizer) {
        
        if(swipe.state == .ended){
            if(swipe.direction == .right){
                if(month > 1){
                    diff = diff - 1
                    let nextMonth: Date = Calendar.current.date(byAdding: .month, value: diff, to: Date())!
                    let calendar = Calendar.current
                    month = calendar.component(.month, from: nextMonth)
                    
                    let cal = CalendarHandler()
                    var user: String = (AccessToken.current?.userId)!
                    if(!shouldLoadUserCalendar){
                        user = nonUserUID!
                    }
                    
                    cal.getCalMonth(forMonth: String(month), ofYear: String(year), withUser: user, completion: { (data, m, error) in
                        guard let events = data, let month = m  else{
                            print(error)
                            return
                        }
                        self.dates = events
                        self.navigationItem.title = month + " " + String(self.year)
                        self.collectionView.reloadData()
                    })
                }else{
                    month = 12
                    yDiff = yDiff - 1
                    
                    let nextYear: Date = Calendar.current.date(byAdding: .year, value: yDiff, to: Date())!
                    let calendar = Calendar.current
                    year = calendar.component(.year, from: nextYear)
                    
                    let cal = CalendarHandler()
                    var user: String = (AccessToken.current?.userId)!
                    if(!shouldLoadUserCalendar){
                        user = nonUserUID!
                    }
                    
                    cal.getCalMonth(forMonth: String(month), ofYear: String(year), withUser: user, completion: { (data, m, error) in
                        
                        guard let events = data, let month = m  else{
                            print(error)
                            return
                        }
                        
                        self.dates = events
                        self.navigationItem.title = month + " " + String(self.year)
                        self.collectionView.reloadData()
                    })
                }
                
            }else if(swipe.direction == .left){
                if(month < 12 ){
                    diff = diff + 1
                    let nextMonth: Date = Calendar.current.date(byAdding: .month, value: diff, to: Date())!
                    let calendar = Calendar.current
                    month = calendar.component(.month, from: nextMonth)
                    
                    let cal = CalendarHandler()
                    var user: String = (AccessToken.current?.userId)!
                    if(!shouldLoadUserCalendar){
                        user = nonUserUID!
                    }
                    
                    cal.getCalMonth(forMonth: String(month), ofYear: String(year), withUser: user, completion: { (data, m, error) in
                        
                        guard let events = data, let month = m  else{
                            print(error)
                            return
                        }
                        
                        self.dates = events
                        self.navigationItem.title = month + " " + String(self.year)
                        self.collectionView.reloadData()
                    })
                }else{
                    month = 1
                    yDiff = yDiff + 1
                    
                    let nextYear: Date = Calendar.current.date(byAdding: .year, value: yDiff, to: Date())!
                    let calendar = Calendar.current
                    year = calendar.component(.year, from: nextYear)
                    
                    let cal = CalendarHandler()
                    var user: String = (AccessToken.current?.userId)!
                    if(!shouldLoadUserCalendar){
                        user = nonUserUID!
                    }
                    
                    cal.getCalMonth(forMonth: String(month), ofYear: String(year), withUser: user, completion: { (data, m, error) in
                        
                        guard let events = data, let month = m  else{
                            print(error)
                            return
                        }
                        
                        self.dates = events
                        self.navigationItem.title = month + " " + String(self.year)
                        self.collectionView.reloadData()
                    })
                }
                
            }
        }
        
        
    }


}

extension CalendarViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalendarViewCell
        
       // cell.date.layer.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height - 50)
        cell.date.layer.backgroundColor = UIColor.white.cgColor
        
       cell.backgroundColor = .white
        
        if(indexPath.row < 7){
            
            cell.date.font = UIFont.boldSystemFont(ofSize: cell.date.font.pointSize)
            
            switch indexPath.row{
            case 0:
                cell.date.text = "M"
            case 1:
                cell.date.text = "T"
            case 2:
                cell.date.text = "W"
            case 3:
                cell.date.text = "T"
            case 4:
                cell.date.text = "F"
            case 5:
                cell.date.text = "S"
            case 6:
                cell.date.text = "S"
            default:
                print("Error switching IndexPath in Calendar View cellForItemAt")
            
            }
        }else{
            cell.date.font = UIFont.systemFont(ofSize: cell.date.font.pointSize)
            let thisDay: CalendarDay = dates[indexPath.row-7]
            cell.date.text = thisDay.getDate()
            
            if(cell.date.text == "0"){
                cell.date.text = " "
            }
            
            if(thisDay.doesHaveEvents()){
                if(thisDay.countEvents() > 1){
                    cell.date.layer.backgroundColor = UIColor.yellow.cgColor
                }else if(thisDay.countEvents() == 1){
                    cell.date.layer.backgroundColor = UIColor.green.cgColor
                }
                
            }
            
            let date = Date()
            let calendar = Calendar.current

            if(String(month) == String(calendar.component(.month, from: date))){
                if(thisDay.getDate() == String(calendar.component(.day, from: date))){
                    cell.date.layer.backgroundColor = UIColor.lightGray.cgColor
                    selectedCell = indexPath.row
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let day = dates[indexPath.row-7]
        if( day.getDate() != "0" && day.getDate() != " "){
            showTimeline(ofDay: day)
            
        }
    }
    
    func showTimeline(ofDay: CalendarDay){
        let dayView = DayViewController()
        dayView.today = ofDay
        navigationController?.pushViewController(dayView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dates.count + 7
    }
    
    
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        
        
        if(dates.count == 6*7){
            return CGSize(width: view.frame.width/7, height: view.frame.height/9)
        }else{
            return CGSize(width: view.frame.width/7, height: view.frame.height/8)
        }
    }
    
}

