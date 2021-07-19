//
//  CalendarHandler.swift
//  CalTest
//
//  Created by Jamie McAllister on 19/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation
//import FacebookCore
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class CalendarHandler{
    var cal: CalendarViewController? = nil
    let db: Firestore!
    let storage: Storage
    var month = [CalendarDay]()
    //MARK: Initialisers
    init(_ calendar:CalendarViewController){

        cal = calendar
        db = Firestore.firestore()
        storage = Storage.storage()
    }
   init(){
        db = Firestore.firestore()
        storage = Storage.storage()
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
            self.getRequestEvents(forUser: fromUser, onDay: forDay, ofMonth: ofMonth, inYear: inYear) { invites in
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
    
    //MARK: Get and set User and Person
    func saveUser(person: Person){
        db.collection("User").document(person.uid).setData(person.toArray())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                self.saveProfilePicture(forUser: person.uid, withPicture: person.picture!)
            }
        }
    }
    
    func createUser(person: Person){
        print(person.toArray())
        db.collection("User").document(Auth.auth().currentUser!.uid).setData(person.toArray())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                self.saveProfilePicture(forUser: Auth.auth().currentUser!.uid, withPicture: person.picture!)
            }
        }
    }
    
    func saveProfilePicture(forUser: String, withPicture: UIImage){
        
        //create reference
        let storageRef = storage.reference()
        
        //upload Image to cloud storage
        var picRef = storageRef.child("profiles/\(forUser)/profile.jpg")
        
        // Upload the file to the path
        let data = withPicture.jpegData(compressionQuality: 1)
        let uploadTask = picRef.putData(data!, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            print("something apparently went wrong")
            return
          }
        }

        
        
        
    }
    
    @available(swift, obsoleted:4.0, message:"I have no idea what this does, use getPerson() to retrieve user information")
    func setUser(){
        
        db.collection("User")
            .whereField("user", isEqualTo: String(Auth.auth().currentUser!.uid))
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print(document)
                       // print("\(document.documentID) => \(document.data())")
                        let me = Person(document: document)
                        
                    }
                    
                }
             //   completion(events)
            }
    }
   
    func doesUserExist(_ completion: @escaping (Bool)->Void){
        db.collection("User").document(Auth.auth().currentUser!.uid).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                fatalError("Unable to Retrieve documents to determine if user exists")
            } else {
                if(querySnapshot?.data() == nil){
                    print("User document does not exist, Instructing App to begin creation")
                    completion(false)
                }else{
                    completion(true)
                }
            }
        }
        
    }
    
    func getperson(forUser: String, completion: @escaping (_ p: Person)->Void){
        db.collection("User").document(forUser).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.data() != nil){
                    let person = Person(document: querySnapshot!)
                    // Create a reference to the file you want to download
                    let storageRef = self.storage.reference()
                    let picRef = storageRef.child("profiles/\(person.uid)/profile.jpg")

                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    picRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                      if let error = error {
                        print("No Image Exists for this user")
                        completion(person)
                        // Uh-oh, an error occurred!
                      } else {
                        let image = UIImage(data: data!)
                        person.picture = image
                        completion(person)
                      }
                    }
                }
            }
        }
    }
    
    func getperson(forPhone: String, completion: @escaping (Person, Bool)->Void){
        db.collection("User").whereField("mobile", isEqualTo: forPhone).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.isEmpty == true){
                    let p = Person(id: "", first: "", last: "")
                    completion(p, false)
                }
                for document in (querySnapshot?.documents)! {
                    let person = Person(document: document)
                    //Get profile Pic
                    let storageRef = self.storage.reference()
                    let picRef = storageRef.child("profiles/\(person.uid)/profile.jpg")

                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    picRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                      if let error = error {
                        print("No Image Exists for this user")
                        completion(person, true)
                        // Uh-oh, an error occurred!
                      } else {
                        let image = UIImage(data: data!)
                        person.picture = image
                        completion(person, true)
                      }
                    }
                }
            }
        }
    }
    
    func getperson(withUID: String, completion: @escaping (Person, Bool)->Void){
        db.collection("User").document(withUID).getDocument(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.data() == nil){
                    let p = Person(id: "", first: "", last: "")
                    completion(p, false)
                }else{
                    let friend = Person(document: querySnapshot!)
                    completion(friend, true)
                }
            }
        })
    }
    
    //MARK: Friends
    
    func getFriendsList(){
        db.collection("friends").whereField("sender", isEqualTo: Settings.sharedInstance.me.uid).whereField("accepted", isEqualTo: true).getDocuments { shapshot, err in
            print(shapshot?.count)
        }
    }
    
    func addFriend(){
        fatalError("Not Implemented Yet")
    }
    
    func removeFriend(){
            fatalError("Not Implemented Yet")
        }
    func acceptFriendRequest(){
        fatalError("Not Implemented Yet")
    }
    
    func rejectFriendRequest(){
        fatalError("Not Implemented Yet")
    }
    
    //Event Invites
    //MARK: Invites
    func saveNewRequest(event: String, user: String, day: Int, month: Int, year: Int){
        var ref: DocumentReference?
        ref = db.collection("Invite").addDocument(data: ["eventId":event, "user":user, "sender": Auth.auth().currentUser!.uid, "response": "no", "day": day, "month": month, "year": year])
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
               // self.sendMessage(to: user, type: 1, withRef: ref!)
                print(ref?.documentID)
            }
        }
    }
    
    func isUserInvited(_ user: String, toEvent: String, completion: @escaping(Bool)->Void){
        
        print("user: \(user)")
        print("Event: \(toEvent)")
        
        db.collection("Invite").whereField("eventId", isEqualTo: toEvent).whereField("user", isEqualTo: user).getDocuments { snap, err in
            
            let docs = snap!.count
            print("docs \(docs)")
            if(docs > 0){
                completion(true)
            }else{
                completion(false)
            }
            
            
            
        }
    }
    
    func getRequests(forEvent: String, completion: @escaping ([Person], [Person], [Person])->Void){
        var going = [Person]()
        var notGoing = [Person]()
        var invited = [Person]()
        //get all invites for the event
        db.collection("Invite").whereField("eventId", isEqualTo: forEvent).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.isEmpty == true){
                    completion([], [], [])
                }
                for document in (querySnapshot?.documents)! {
                    let data = document.data()
                    //get the user data for the invitee
                    self.getperson(withUID: data["user"] as! String, completion: { (p, e) in
                       // put the user in the correct array
                        switch data["response"] as! String{
                        case "going":
                            going.append(p)
                            break
                        case "not":
                            notGoing.append(p)
                            break
                        default:
                            invited.append(p)
                        }
                        completion(going, notGoing, invited)
                    })
                        
                }
            }
        }
        
    }
    
    func getRequests(forUser: String, completion: @escaping ([Request]) -> Void){
        
        var requests = [Request]()
        
        db.collection("Invite").whereField("user", isEqualTo: forUser).whereField("response", isEqualTo: "no").getDocuments(completion: {(querySnapshot, err) in
            if(querySnapshot?.isEmpty == true){
                completion([])
            }
            for document in (querySnapshot?.documents)! {
                let r = Request()
                let d = document.data()
                r.apply(document: document)
                self.getperson(forUser: d["sender"] as! String, completion: {(p) in
                    r.person = p
                    self.getEvent(withId: d["eventId"] as! String, completion: {(e) in
                        r.event = e
                        requests.append(r)
                        completion(requests)
                    })
                })
                
            }
            
        })
        
    }
    
    func getRequestCount(forEvent: String, completion: @escaping (Int)->Void){
        var going = 0
        //get all invites for the event
        db.collection("Invite").whereField("eventId", isEqualTo: forEvent).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.isEmpty == true){
                    completion(0)
                }
                for document in (querySnapshot?.documents)! {
                    let data = document.data()
                    //get the user data for the invitee
                    self.getperson(withUID: data["user"] as! String, completion: { (p, e) in
                       // put the user in the correct array
                        if(data["response"] as! String == "going"){
                            going += 1
                        
                        }
                        completion(going)
                        })
                }
            }
        }
        
    }
    
    func respondToRequest(_ request: String, with: String, completion: @escaping ()->Void){
        
        db.collection("Invite").document(request).updateData(["response" : with]){_ in
            completion()
        }
    }
    
    func removeRequest(foruser: String, fromEvent: String){
        
        db.collection("Invite").whereField("eventId", isEqualTo: fromEvent).whereField("user", isEqualTo: foruser).getDocuments(completion: {(querySnapshot, err) in
            
            for document in (querySnapshot!.documents){
                let id = document.documentID
                    self.db.collection("Invite").document(id).delete()
            }
            
        })
    }
    
    func getRequestEvents(forUser: String, onDay: Int, ofMonth: Int, inYear: Int, completion: @escaping ([Event]) -> Void){
        
        var events = [Event]()
        
        db.collection("Invite").whereField("user", isEqualTo: forUser)
            .whereField("response", isEqualTo: "going")
            .whereField("day", isEqualTo: onDay)
            .whereField("month", isEqualTo: ofMonth)
            .whereField("year", isEqualTo: inYear)
            .getDocuments(completion: {(querySnapshot, err) in
            if(querySnapshot?.isEmpty == true){
                completion([])
            }else{
                for document in (querySnapshot?.documents)! {
                    let d = document.data()
                    self.getEvent(withId: d["eventId"] as! String, completion: {(e) in
                        events.append(e)
                        completion(events)
                    })
                }
            }
        })
        
    }
    
    //MARK: Status
    func getStatus(forEvent: String, _ completion: @escaping([Status]) -> Void){
        var statuses = [Status]()
        //get all invites for the event
        db.collection("Status").whereField("eventID", isEqualTo: forEvent).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot?.isEmpty == true){
                    completion([])
                }
                for document in (querySnapshot?.documents)! {
                    let status = Status(document: document)
                    status.getPerson(p: document.data()["userID"] as! String, completion: {() in
                        statuses.append(status)
                        completion(statuses)
                    })
                }
            }
            
        }
    }
    
    func submitStatus(forEvent: String, fromUser: String, withMessage: String, _ completion: @escaping()->Void){
        let d = ["eventID": forEvent, "userID": fromUser, "message": withMessage]
        db.collection("Status").addDocument(data: d){(response) in
            completion()
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
            return NSError(domain: "biz.appit.friendal", code: 101, userInfo: ["message": "An error occured while accessing the calendar."])
        }else if(from.domain == NSURLErrorDomain && from.code == -1009){
            return NSError(domain: "biz.appit.friendal", code: 100, userInfo: ["message": "The Internet connection appears to be offline."])
        }else{
            return NSError(domain: "biz.appit.friendal", code: 001, userInfo: ["message": "An unknown error has occured while making your request."])
        }
    }

    
    //MARK: Helper Functions
    
    func sortByIdReverse(_ statuses: [Status]) -> [Status]{
        
        var stats = statuses
        var shifted = true
        
        repeat {
            shifted = false
            for (index, status) in stats.enumerated(){
                var stat = status
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
