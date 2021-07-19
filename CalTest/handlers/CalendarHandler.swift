//
//  CalendarHandler.swift
//  CalTest
//
//  Created by Andrew McAllister on 19/11/2017.
//  Copyright © 2017 MakeItForTheWeb Ltd. All rights reserved.
//

import Foundation
//import FacebookCore
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class CalendarHandler: Handler{
    
    var cal: CalendarViewController? = nil
    var month = [CalendarDay]()
    //MARK: Initialisers
    init(_ calendar:CalendarViewController){
        super.init()
        cal = calendar
    }
    
    override init(){
        super.init()
    }
    
    //MARK: Calendar Month Day and Events
    func getMonth(forMonth: Int, ofYear: Int, withUser: String, completion:([CalendarDay]) -> Void){
        var dateComponents = DateComponents()
        dateComponents.year = ofYear
        dateComponents.month = forMonth
        dateComponents.day = 1
        
        let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
        let date = userCalendar.date(from: dateComponents) //create a Date() object from the date components of the 1st of the chosen month and year
        var weekday = userCalendar.component(.weekday, from: date!) as Int
        
        var length = 0
        let thisMonth = userCalendar.component(.month, from: date!)
        let thisYear = userCalendar.component(.year, from: date!)
        var tDay = 1

        if(thisMonth == 2){
            if(thisYear % 2 == 0){
                length = 29
            }
            else{
                length = 28
            }
        }else{
            if(thisMonth % 2 == 0){
                length = 30
            }else{
                length = 31
            }
        }
        /*
         date:          Array
         
         Monday: 1      0
         Tuesday: 2     1
         Wed: 3         2
         Thur: 4        3
         Fri: 5         4
         Sat: 6         5
         sun: 7         6
         
         */

        weekday -= 1//shift day of the week backwards - sunday becomes 0, Monday 1 etc
        //REMEMBER: Sunday is day 0
        if(weekday>0){
            while month.count < weekday-1{
                month.append(CalendarDay())
            }
        }
        else{
            //weekday is less than 1 so MUST be sunday
            //need 6 empty days
            var day = 1
            while day < 7 {
                month.append(CalendarDay())
                day += 1
            }
        }


        while tDay<length+1{
            
            let day = CalendarDay(onDay: tDay, ofMonth: dateComponents.month!, ofYear: dateComponents.year!)
            month.append(day)
            //getEvents(forDay: tDay, ofMonth: forMonth, inYear: ofYear, fromUser: Auth.auth().currentUser!.uid, withTDay: month.count)
            
            
            tDay += 1
        }
        completion(month)
        
    }
    
    
    fileprivate func getUserEvents(_ fromUser: String, _ forDay: Int, _ ofMonth: Int, _ inYear: Int, _ completion: @escaping ([Event]) -> Void) {
        var events = [Event]()
        
        db.collection("Event")
            .whereField("user", isEqualTo: fromUser)
            .whereField("day", isEqualTo: String(forDay))
            .whereField("month", isEqualTo: String(ofMonth))
            .whereField("year", isEqualTo: String(inYear))
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print(document)
                        // print("\(document.documentID) => \(document.data())")
                        let event = Event(document: document)
                        events.append(event)
                    }
                    
                }
                completion(events)
            }
    }
    
    func getEvents(forDay: Int, ofMonth: Int, inYear: Int, fromUser: String, completion: @escaping([Event]) -> Void){
       var events = [Event]()
        
        
        getUserEvents(fromUser, forDay, ofMonth, inYear, {(userEvents) in
            events.append(contentsOf: userEvents)
            inviteHandler.getRequestEvents(forUser: fromUser, onDay: forDay, ofMonth: ofMonth, inYear: inYear) { invites in
                events.append(contentsOf: invites)
                completion(events)
            }
        })
        
        
    }
    
    func getEvent(withId: String, completion: @escaping(Event) -> Void){
        
        db.collection("Event").document(withId).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let event = Event(document: document!)
                completion(event)
            }
                
        }
                
    }
    
    
    func addEvent(event: Event){
        var ref: DocumentReference? = nil
        ref = db.collection("Event").addDocument(data: event.toArray())
            { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
    }
    
    func addEvent(event: Event, completion: @escaping (String) -> Void){
        var ref: DocumentReference? = nil
        ref = db.collection("Event").addDocument(data: event.toArray())
            { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        completion("Error")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        completion(ref!.documentID)
                    }
                }
    }
    
    func update(event: Event, withId: String){
        db.collection("Event").document(withId).setData(event.toArray()){err in
            print("Update?")
            
        }
        
    }
    //MARK: Message
    
    func sendMessage(to: String, type: Int, withRef: String){
        
        //let message = ["user": to, "type": type, "read": false, "sender": Auth.auth().currentUser?.uid] as [String : Any]
        
        //db.collection("Message").addDocument(data: message)
        
    }
    
    func getMessages(){
        /*
         1: Request Recieved
         2: Request Responded
         3: Event Calncelled
         4: Event Moved
         */
        
    }
    
  /*
    
    func cancelEvent(event: String, forUser:String, completion:@escaping (_ respond:Bool)->()){
        DispatchQueue.global(qos: .userInteractive).async {
        let url = URL(string: self.BASE_URL + "/calendar/cancelEvent.php")//?id=" + forUser + "&eid=" + event)
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "id=" + forUser
            
            postString += "&eid=" + event
            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            if error != nil {
                print("ERROR")
                print(error!)
                DispatchQueue.main.async {
                    completion(false)
                }
            }else{
                DispatchQueue.main.async {
                    completion(true)
                }
            }//end else
        }//end task
        task.resume()
        }//end async
    }//end cancel event
    

    func getEventStatus(_ id: String, completion: @escaping ([Status]?, NSError?) ->()){
        let url = URL(string: self.BASE_URL + "/calendar/getStatuses.php")//?id=" + String(describing: id))
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
        
        request.httpMethod = "POST"
        
        var postString:String
        
        postString = "id=" + id
        
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            if error != nil {
                print("ERROR in request")
                DispatchQueue.main.async {
                    completion(nil, self.getError(from: error! as NSError))
                }
            }else{
        
                do{
                    guard let data = data else{return}
                    
                    
                    let statuses = try
                        JSONDecoder().decode([Status].self, from: data)
                    
                    DispatchQueue.main.async {
                        var sorted = self.sortByIdReverse(statuses)
                        var propogated = self.propogateAds(sorted)
                       completion(propogated, nil)
                    }
                    
                }catch let error{
                    print(error)
                    completion(nil, self.getError(from: error as NSError))
                }
        
            }
        }
        task.resume()
    }
    
    func saveNewEvent(event: Event, completion: @escaping (String) ->()){
        
        let url = URL(string: self.BASE_URL + "/calendar/addEvent.php")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        var postString:String
            
        postString = "title=" + event.title!
        
        postString += "&start=" + event.start!
        
        postString += "&end=" + event.end!
        
        postString += "&day=" + event.date!
        
        postString += "&month=" + event.month!
        
        postString += "&year=" + event.year!
        
        postString += "&privacy=" + String(describing: event.isHidden())
        
        postString += "&allday=" + String(describing: event.getAllDayInt())
        
//        postString += "&id=" + (AccessToken.current?.userId)!
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            if error != nil {
                print("ERROR")
                print(error!)
            }else{
                completion(String(data: data!, encoding: String.Encoding.utf8)!)
            }
        }//end task
        task.resume()
    }//end save Event
    
    
    func updateEvent(event: Event/*,completion: @escaping (String) ->()*/){
        
        let url = URL(string: self.BASE_URL + "/calendar/updateEvent.php")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        var postString:String
        
        postString = "title=" + event.title!
        
        postString += "&start=" + event.start!
        
        postString += "&end=" + event.end!
        
        postString += "&day=" + event.date!
        
        postString += "&month=" + event.month!
        
        postString += "&year=" + event.year!
        
        postString += "&privacy=" + String(describing: event.isHidden())
        
        postString += "&allday=" + String(describing: event.getAllDayInt())
        
//        postString += "&uid=" + (AccessToken.current?.userId)!
        
        postString += "&id=" + event.id
        
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            if error != nil {
                print("ERROR")
                print(error!)
            }else{
                //completion(String(data: data!, encoding: String.Encoding.utf8)!)
            }
        }//end task
        task.resume()
    }//end update Event
    
    
    
    
    func acceptRequest(_ id: String, completion: @escaping () ->()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            
            let url = URL(string: self.BASE_URL + "/calendar/acceptRequest.php")//?id=" + id)
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "id=" + id
            
            
            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
            task.resume()
        }
    }
    
    func declineRequest(_ id: String, completion: @escaping () ->()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            
            let url = URL(string: self.BASE_URL + "/calendar/declineRequest.php")//?id=" + id)
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "id=" + id

            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
            task.resume()
        }
    }
    
    func getGoing(forEvent: String, completion: @escaping ([Invitee]?, NSError?) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            var invitees: Array<Invitee> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/getGoing.php")//?id=" + forEvent)
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "id=" + forEvent

            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    DispatchQueue.main.async {
                        completion(nil, self.getError(from: error! as NSError))
                    }
                }else{
                   
                    if let content = data{
                        do{
                            
                            //Array
                            let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            let jdata = json as! Array<[String: Any]>
                            for invitee in jdata {
                                
                                invitees.append(Invitee(invitee["id"] as! String, uid: invitee["uid"] as! String, eventId: invitee["eventID"] as! String, isCancelled: invitee["isCancelled"] as! String) )
                            }
                            DispatchQueue.main.async {
                                completion(invitees, nil)
                            }
                        }catch let error{
                            DispatchQueue.main.async {
                                completion(nil, self.getError(from: error as NSError))
                            }
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
    }//end getGoing
    
    func isInvitee(_ user: String, forEvent: String, completion: @escaping (Bool) ->()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            var invitees: Array<Invitee> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/isInvitee.php")//?eid=" + forEvent + "&uid=" + user)
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "eid=" + forEvent
            
            postString += "&uid=" + user
            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                    
                    if let content = data{
                        do{
                            
                            //Array
                            let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                            
                            
                            DispatchQueue.main.async {
                                if(json as! Int == 1){
                                    completion(true)
                                }else{
                                    completion(false)
                                }
                            }
                        }catch let error{
                           print(error)
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
        
    }
    
    func getNotGoing(forEvent: String, completion: @escaping ([Invitee]?, NSError?) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            
            
            var invitees: Array<Invitee> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/getNotGoing.php")//?id=" + forEvent)
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "id=" + forEvent

            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    DispatchQueue.main.async {
                        completion(nil, self.getError(from: error! as NSError))
                    }
                }else{
                    
                    if let content = data{
                        do{
                            
                            //Array
                            let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            let jdata = json as! Array<[String: Any]>
                            for invitee in jdata {
                                
                                invitees.append(Invitee(invitee["id"] as! String, uid: invitee["uid"] as! String, eventId: invitee["eventID"] as! String))
                            }
                            DispatchQueue.main.async {
                                completion(invitees, nil)
                            }
                        }catch let error{
                            DispatchQueue.main.async {
                                completion(nil, self.getError(from: error as NSError))
                            }
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
    }//end getNotGoing
    
    func getInvited(forEvent: String, completion: @escaping ([Invitee]?, NSError?) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            
            
            var invitees: Array<Invitee> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/getInvited.php")//?id=" + forEvent)
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "id=" + forEvent
            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    DispatchQueue.main.async {
                        completion(nil, self.getError(from: error! as NSError))
                    }
                }else{
                    
                    if let content = data{
                        do{
                            
                            //Array
                            let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            let jdata = json as! Array<[String: Any]>
                            for invitee in jdata {
                                
                                invitees.append(Invitee(invitee["id"] as! String, uid: invitee["uid"] as! String, eventId: invitee["eventID"] as! String, invitedBy: invitee["sender"] as! String))
                            }
                            DispatchQueue.main.async {
                                completion(invitees, nil)
                            }
                        }catch let error{
                            DispatchQueue.main.async {
                                completion(nil, self.getError(from: error as NSError))
                            }
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
    }//end getInvited
    
    func getSettings(forUser: String){
        DispatchQueue.global(qos: .userInteractive).async {
            
            let url = URL(string: self.BASE_URL + "/calendar/getUserOptions.php")//?uid=" + forUser)
            
            //let token = Messaging.messaging().fcmToken
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            
            postString = "&uid=" + forUser
            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                    
                    if let content = data{
                        do{
                            //Array
                            let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            let jdata = json as! Dictionary<String, String>
                            
                            Settings.sharedInstance.id = Int(jdata["id"]!)
//                            Settings.sharedInstance.uid = jdata["uid"]!
                            Settings.sharedInstance.dateFormat = Int(jdata["date_format"]!)!
                            Settings.sharedInstance.privacy = Int(jdata["default_privacy"]!)!
                            

                        }catch{
                            
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
    }//end getInvited
    
    func setSettings(){
        DispatchQueue.global(qos: .userInteractive).async {
            let settings = Settings.sharedInstance
            
            let url = URL(string: self.BASE_URL + "/calendar/updateUserOptions.php")
            
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String = ""
            
//            postString  = "uid=" + settings.uid
         //   postString += "&format=" + String(describing: settings.dateFormat)
            //postString += "&privacy=" + String(describing: settings.privacy)//
            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                  print("Settings Saved")
                }
            }//end Task
            task.resume()
        }//end async
    }//end getInvited
    
    
    func saveNewStatus(event: String, title: String, sender: String, senderName: String, message: String, completion: @escaping (String) ->()){
        let url = URL(string: self.BASE_URL + "/calendar/addStatus.php")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        var postString:String
        
        postString = "id=" + event
        postString += "&message=" + message
//        postString += "&poster=" + (AccessToken.current?.userId)!
        postString += "&eventTitle=" + title
        postString += "&posterName=" + senderName
        request.httpBody = postString.data(using: String.Encoding.utf8)
        print(postString)
        let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            if error != nil {
                print("ERROR")
                print(error!)
            }else{
                DispatchQueue.main.async {
                    completion(String(data: data!, encoding: String.Encoding.utf8)!)
                }
                
            }
        }//end task
        task.resume()
    }//end save Event
    
    
    func registerDviceToken(){
        print("sending update to register.php")
        let url = URL(string: self.BASE_URL + "/calendar/register.php")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        var postString:String = ""
//        postString = "token=" + Messaging.messaging().fcmToken!
        
      //  postString += "&sender=" + (AccessToken.current?.userId)!
        
        postString += "&device=" + UIDevice.current.model
        
        postString += "&os=" + UIDevice.current.systemVersion
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            if error != nil {
                print("ERROR")
                print(error!)
            }
        }//end task
        task.resume()
    }//end save request
    
    
    func doGraph(request: String, params: String, completion: @escaping (Dictionary<String, Any>?, NSError?) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            
          //  var graph = GraphRequest.init(graphPath: request)
    //        graph.parameters = ["fields": params]
          //  graph.parameters = nil
     /*       graph.start({ (response, data) in
                
                switch data {
                    
                case .success(let d):
                    DispatchQueue.main.async {
                        
                        completion(d.dictionaryValue!, nil)
                    }
                    
                case .failed(let e):
                    DispatchQueue.main.async {
                        completion(nil, self.getError(from: e as NSError))
                    }
                }//end switch
                
            })//end request*/
        }//end async
    }//end doGraph
    */
    func getError(from: NSError) ->NSError{
        print("===GETERROR===")
        if(from.domain == "NSCocoaErrorDomain"){
            return NSError(domain: "com.makeitfortheweb.palendar", code: 101, userInfo: ["message": "An error occured while accessing the calendar."])
        }else if(from.domain == NSURLErrorDomain && from.code == -1009){
            return NSError(domain: "com.makeitfortheweb.palendar", code: 100, userInfo: ["message": "The Internet connection appears to be offline."])
        }else{
            return NSError(domain: "com.makeitfortheweb.palendar", code: 001, userInfo: ["message": "An unknown error has occured while making your request."])
        }
    }

    
    //MARK: Helper Functions
    
    func sortByIdReverse(_ statuses: [Status]) -> [Status]{
        
        var stats = statuses
        var shifted = true
        
        repeat {
            shifted = false
            for (index, status) in stats.enumerated(){
                let stat = status
                if(stat.isAd != nil){
                    print("not nil")
                }else{
                    stat.isAd = false
                }
                if(index == 0){
                }else{
                    if(status.id! > stats[index - 1].id!){
                        let taken = stats[index - 1]
                        stats[index - 1] = stat
                        stats[index] = taken
                        shifted = true
                    }
                }
            }
        } while (shifted);
        
        return stats
        
    }
    
    func propogateAds(_ statuses: [Status]) -> [Status]{
        
        var stat = statuses
        
        
        if(stat.count > 0){
            print("Propogating ads: ", statuses.count)
            var index = 1
            repeat{
                print(index)
                if(index < 1){
                    
                }else{
                    let chance = arc4random()%10
                    
                    print("chance: ", chance)
                    
                    if(chance < 3 && !stat[index - 1].isAd!){
                        print("adding an add at: ", index)
                        let statAd = Status(isAd: true)
                        
                        stat.insert(statAd, at: index)
                        // print(statuses)
                    }
                }
                index = index + 1
            }while(index <= stat.count)
        }else{
            let statAd = Status(isAd: true)
            
            stat.insert(statAd, at: 0)
        }
        
//        print("=================================")
//        print("=========Propogated List=========")
//        print("=================================")
//        print(stat)
//        print("=================================")
//        print("=================================")
//        print("=================================")
        
        return stat
    }
}//end class
