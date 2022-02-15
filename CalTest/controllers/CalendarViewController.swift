//
//  ViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 19/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class CalendarViewController: UIViewController, UIGestureRecognizerDelegate {
    var dates = [CalendarDay]()
    let cellId = "day"
    var selectedCell: Int = -1
    let errorLabel = UILabel()
    
    let tutorialView = UIView(frame: .zero)
    
    var shouldLoadMyCalendar: Bool = true
    
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
        
        let date = Date()
        let calendar = Calendar.current
        month = calendar.component(.month, from: date)
        year = calendar.component(.year, from: date)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        me.load { shouldLoad in
            
            if(shouldLoad){
                self.doLoad()
            }else{
                self.showLoginScreen()
            }
        }
        doLoad()
        //MARK: Uncomment this line to debug login features
        //do{ try Auth.auth().signOut() }catch{}
        super.viewDidLoad()
    }
    
    func isLoggedIn() ->Bool {
        
        if(Auth.auth().currentUser != nil){
               return true
            }else{
                if(!self.shouldLoadMyCalendar){
                 //   AppEventsLogger.log("Viewed Friend Calendar")
                    return false
                }else{
                 //   AppEventsLogger.log("viewed Own Calendar")
                    return false
                }
            }
    }
    
    func showLoginScreen(){
        let welcomeVC = WelcomeViewController()
        welcomeVC.modalPresentationStyle = .fullScreen
        navigationController?.present(welcomeVC, animated: true, completion: nil)
    }
    
    func setupCalendar(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        if let tut = UserDefaults.standard.object(forKey: "didCloseCalendarTutorial") as? Bool{
            if(!tut){
                setupTutorial()
            }
        }else{
            setupTutorial()
        }
        
    }
    
    func validateLogin(){
        if(isLoggedIn()){
            doLoad()
        }else{
            showLoginScreen()
        }
    }
    
    func doLoad(){
        dates.removeAll()
        collectionView.reloadData()
        errorLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height - 100)
        errorLabel.textAlignment = .center
        errorLabel.text = "The calendar is loading."
        errorLabel.numberOfLines = 0
        errorLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(CGFloat(0.5))
        errorLabel.isHidden = false
        collectionView.addSubview(errorLabel)
        
        Settings.sharedInstance.load()
        
        let cal = CalendarHandler(self)

      //  var user: String = (AccessToken.current?.userId)!
        if(!shouldLoadMyCalendar){
           // user = Settings.sharedInstance.selectedFriendId!
        }
        
        navigationItem.title = monthAsString(month) + " " + String(self.year)
        if(shouldLoadMyCalendar){
            cal.getMonth(forMonth: month, ofYear: year, withUser: Auth.auth().currentUser!.uid, completion: applyMonth(days:))
            setupCalendar()
            collectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: cellId)
            collectionView.dataSource = self
            collectionView.delegate = self
        }else{
            cal.getMonth(forMonth: month, ofYear: year, withUser: Settings.sharedInstance.selectedFriendId!, completion: applyMonth(days:))
            setupCalendar()
            collectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: cellId)
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    func applyMonth(days : [CalendarDay]){
        errorLabel.isHidden = false
        errorLabel.text = "The calendar is loading."
        
        //first iteration
        
        dates = days //local variable of days parameter
        
        
        if(shouldLoadMyCalendar){
            firstIteration(forMyCalendar: shouldLoadMyCalendar) { bridgingEvents in
                for day in self.dates{ //second iteration --- check if day falls between start and end dates of each bridging event
                     for event in bridgingEvents{
                         if(day.date > event.getStartDate() && day.date < event.getEndDate()){
                            event.isBridge = true
                             day.addEvent(event: event)
                         }//end date check if statement
                         
                     }//end event loop
                     self.collectionView.reloadData()
                 }//end second iteration
            }
           
            
        }else{
           /* for day in dates{
                calendarHandler.getEvents(forDate: day.date, fromUser: Settings.sharedInstance.selectedFriendId!){(events: [Event]) in
                    for event in events{

                        //all events either started or ended on this day so must be added

                        day.addEvent(event: event)

                        if(event.bridgesDays){
                            //event started or ended on another day
                            bridgingEvents.append(event)
                        }//end bridging day check

                    }//end event loop
                    self.collectionView.reloadData()
                }//end completion handler
            }//end first iteration

            for day in dates{ //second iteration --- check if day falss between start and end dates of each bridging event
                for event in bridgingEvents{
                    if(day.date > event.getStartDate() && day.date < event.getEndDate()){
                        day.addEvent(event: event)
                    }//end date check if statement

                }//end event loop
                self.collectionView.reloadData()
            }//end second iteration*/
        }//end should load my calendar else statement
        self.collectionView.reloadData()
        self.errorLabel.isHidden = true
    }//end class
    
    
        func firstIteration(forMyCalendar: Bool, secondIteration: @escaping ([Event])-> Void){//First Iteration of the calendar
            var bridgingEvents = [Event]()
            for day in dates{ //first iteration --- get events and add them to the day ---- pass bridging events for second iteration
                calendarHandler.getEvents(forDate: day.date, fromUser: me.uid){(events: [Event]) in
                    print("\(events.count) events")
                    for event in events{
                        print("=====Event=====")
                        print("title: \(event.title!)")
                        //all events either started or ended on this day so must be added
                        
                        day.addEvent(event: event)
                        
                        if(event.bridgesDays){
                            print("bridges days")
                            //event started or ended on another day
                            bridgingEvents.append(event)
                        }else{
                            print("Event: \(String(describing: event.title)) does not bridge days")
                        }//end bridging day check
                        print("===============")
                    }//end event loop
                    self.collectionView.reloadData()
                    secondIteration(bridgingEvents) //pass the bridging events for the second iteration
                }//end completion handler
            }//end first iteration
    }
    
    func loadBridgingEvents(forMyCalendar: Bool, completion: @escaping ()->Void){ //second Iteration
        
    }
    
    
    @objc func didTapNewEventButton(){
        
        if(shouldLoadMyCalendar){
        
            let addVC = CalendarNavigationController(rootViewController: NewEventVC()) //create NewEventVC inside CalendarNavigationCotroller
            let vc:NewEventVC = addVC.topViewController as! NewEventVC//set a reference to the new event Vc as vc
        
            vc.calendarVC = self // set the newEventVC.calendarVC to this class
        
            self.present(addVC, animated: true, completion: ({() in //present the new event VC
                
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
                    //TODO: Handle swipe gestures
                    let cal = CalendarHandler(self)
                    if(!shouldLoadMyCalendar){
                     //   user = Settings.sharedInstance.selectedFriendId!
                    }
                    navigationItem.title = monthAsString(month) + " " + String(self.year)
                    cal.getMonth(forMonth: month, ofYear: year, withUser: Auth.auth().currentUser!.uid, completion: applyMonth(days:))
                }else{
                    month = 12
                    yDiff = yDiff - 1
                    
                    let nextYear: Date = Calendar.current.date(byAdding: .year, value: yDiff, to: Date())!
                    let calendar = Calendar.current
                    year = calendar.component(.year, from: nextYear)
                    
                    let cal = CalendarHandler(self)
                   
                    if(!shouldLoadMyCalendar){
                     //   user = Settings.sharedInstance.selectedFriendId!
                    }
                    navigationItem.title = monthAsString(month) + " " + String(self.year)
                    cal.getMonth(forMonth: month, ofYear: year, withUser: Auth.auth().currentUser!.uid, completion: applyMonth(days:))
                }
                
            }else if(swipe.direction == .left){
                if(month < 12 ){
                    diff = diff + 1
                    let nextMonth: Date = Calendar.current.date(byAdding: .month, value: diff, to: Date())!
                    let calendar = Calendar.current
                    month = calendar.component(.month, from: nextMonth)
                    
                    let cal = CalendarHandler(self)
                    //var user: String = (AccessToken.current?.userId)!
                    if(!shouldLoadMyCalendar){
                       // user = Settings.sharedInstance.selectedFriendId!
                    }
                    navigationItem.title = monthAsString(month) + " " + String(self.year)
                    cal.getMonth(forMonth: month, ofYear: year, withUser: Auth.auth().currentUser!.uid, completion: applyMonth(days:))
                }else{
                    month = 1
                    yDiff = yDiff + 1
                    
                    let nextYear: Date = Calendar.current.date(byAdding: .year, value: yDiff, to: Date())!
                    let calendar = Calendar.current
                    year = calendar.component(.year, from: nextYear)
                    
                    let cal = CalendarHandler(self)
                    //var user: String = (AccessToken.current?.userId)!
                    if(!shouldLoadMyCalendar){
                     //   user = Settings.sharedInstance.selectedFriendId!
                    }
                    
                    navigationItem.title = monthAsString(month) + " " + String(self.year)
                    cal.getMonth(forMonth: month, ofYear: year, withUser: Auth.auth().currentUser!.uid, completion: applyMonth(days:))
                }
                
            }
        }
    }
    
    func monthAsString(_ month:Int) -> String {
        
        switch month {
            
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        default:
            return "Dec"
        
        }
    }
    
    func setupTutorial(){
        
        tutorialView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.addSubview(tutorialView)
        
        tutorialView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tutorialView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tutorialView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tutorialView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tutorialView.backgroundColor = UIColor(rgb: 0x01B30A, alpha: 0.8)
        
        let information = UILabel()
        let close = UILabel()
        
        information.translatesAutoresizingMaskIntoConstraints = false
        close.translatesAutoresizingMaskIntoConstraints = false
        
        // information.backgroundColor = .red
        //close.backgroundColor = .blue
        
        tutorialView.addSubview(information)
        tutorialView.addSubview(close)
        
        
        information.text = "You can swipe left and right to view past and future months"
        information.numberOfLines = 0
        information.font = UIFont.systemFont(ofSize: 24)
        information.textColor = .white
        information.textAlignment = .center
        
        close.text = "Tap here to close"
        close.textAlignment = .center
        close.font = UIFont.boldSystemFont(ofSize: 18)
        close.textColor = .white
        
        close.heightAnchor.constraint(equalToConstant: 50).isActive = true
        close.leftAnchor.constraint(equalTo: tutorialView.leftAnchor).isActive = true
        close.rightAnchor.constraint(equalTo: tutorialView.rightAnchor).isActive = true
        close.bottomAnchor.constraint(equalTo: tutorialView.bottomAnchor, constant: -50).isActive = true
        
        information.topAnchor.constraint(equalTo: tutorialView.topAnchor).isActive = true
        information.leftAnchor.constraint(equalTo: tutorialView.leftAnchor, constant: 5).isActive = true
        information.rightAnchor.constraint(equalTo: tutorialView.rightAnchor, constant: -5).isActive = true
        information.bottomAnchor.constraint(equalTo: close.topAnchor).isActive = true
        
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(didTapToClose))
        
        tutorialView.addGestureRecognizer(tapHandler)
        
    }
    
    @objc func didTapToClose(){
        tutorialView.removeFromSuperview()
        UserDefaults.standard.set(true, forKey: "didCloseCalendarTutorial")
    }


}


//MARK: Data Sources

extension CalendarViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalendarViewCell
        
        cell.eventCircle.isHidden = true
        cell.dayCircle.isHidden = true
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
            cell.date.text = thisDay.getDay()
            
            if(cell.date.text == "0"){
                cell.date.text = " "
            }
            if(thisDay.doesHaveEvents()){
                //cell.date.layer.backgroundColor = UIColor.day.cgColor
                cell.eventCircle.isHidden = false
            }else{
                cell.eventCircle.isHidden = true
            }
            
            if(thisDay.isToday){
                    selectedCell = indexPath.row
                cell.dayCircle.isHidden = false
            }else{
                cell.dayCircle.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row > 6 && indexPath.row < collectionView.numberOfItems(inSection: 0)){
           let day = dates[indexPath.row-7]
            if( day.getDay() != "0" && day.getDay() != " "){
                showTimeline(ofDay: day)
                
            }
        }
    }
    
    func showTimeline(ofDay: CalendarDay){
        let dayView = DayViewController()
        dayView.today = ofDay
        dayView.shouldLoadMyCalendar = self.shouldLoadMyCalendar
        navigationController?.pushViewController(dayView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dates.count + 7
    }
    
    
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(dates.count >= 35){
            return CGSize(width: view.frame.width/7, height: view.frame.height/9)
        }else{
            return CGSize(width: view.frame.width/7, height: view.frame.height/8)
        }
    }
    
}

