//
//  CalendarHandler.swift
//  CalTest
//
//  Created by Jamie McAllister on 19/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation
import FacebookCore
import Firebase

class CalendarHandler{
    
    let BASE_URL = "http://friendal.co.uk"
    //let BASE_URL = "http://192.168.0.67"
    //let BASE_URL = "http://localhost"
    
    func getCalMonth(forMonth: String, ofYear: String, withUser: String, completion: @escaping ([CalendarDay]?, String?, NSError?) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            
            var month: Array<CalendarDay> = []
            var m = ""
            let url = URL(string: self.BASE_URL + "/calendar/getMonth.php?")//month=" + forMonth  + "&year=" + ofYear + "&user=" + withUser)
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "month=" + forMonth
            
            postString += "&year=" + ofYear
            
            postString += "&user=" + withUser
            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil {
                    print("ERROR in request")
                    DispatchQueue.main.async {
                        completion(nil, nil, self.getError(from: error! as NSError))
                    }
                }else{
                    if let content = data{
                        do{
                            //Array
                            let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            let jdata = json as! Array<[String: Any]>
                            for day in jdata {
                                m = day["month"] as! String
                                var hasEvent: Bool = false
                                if let events = day["Events"] as? Array<[String: Any]>{
                                    if(events.count > 0){
                                        hasEvent = true
                                    }
                                }
                                let thisDay = CalendarDay(onDay: day["date"] as! String, ofMonth: day["month"] as! String, ofYear: ofYear, hasEvent: hasEvent)

                                if(hasEvent){
                                    for event in day["Events"] as! Array<[String: String]> {
                                        thisDay.addEvent(event: Event(event["id"]!, title: event["title"]!, date: event["day"]!, month: event["month"]!, year: event["year"]!, start: event["start"]!, end: event["end"]!, count: event["inviteCount"]!, creator: event["UID"]!, privacy: event["make_private"]!, allDay: event["allDay"]!))
                                    }
                                }
                                month.append(thisDay)
                            }
                            DispatchQueue.main.async {
                                completion(month, m, nil)
                            }
                        }catch let err{
                            DispatchQueue.main.async {

                                print(err)
                                completion(nil, nil, self.getError(from: err as NSError))

                            }
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
    }//end getCalMonth
    
    
    func getCalendarDay(_ today: CalendarDay, forUser: String, onDay: String, ofMonth: String, forYear: String, completion: @escaping (NSError?) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
        let url = URL(string: self.BASE_URL + "/calendar/getCalendarDay.php")//?month=" + ofMonth  + "&year=" + forYear + "&day=" + onDay + "&user=" + forUser)
        
        print(url?.absoluteString)
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "month=" + ofMonth
            
            postString += "&year=" + forYear
            
            postString += "&day=" + onDay
            
            postString += "&user=" + forUser
            
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            if error != nil {
                print("ERROR in request")
                DispatchQueue.main.async {
                    completion(self.getError(from: error! as NSError))
                }
            }else{
                
                if let content = data{
                    do{
                        //Array
                        let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        let jdata = json as! Array<[String: String]>
                        print(jdata)
                        today.events = []
                            for event in jdata{
                                print(today)
                                
                                for (key, value) in event{
                                    print(key + ": ", value)
                                }
                                
                                let e = Event(event["id"]!, title: event["title"]!, date: event["day"]!, month: event["month"]!, year: event["year"]!, start: event["start"]!, end: event["end"]!, count: event["inviteCount"]!, creator: event["UID"]!, privacy: event["make_private"]!, allDay: event["allDay"]!)
                                
                                today.addEvent(event: e)
                            }
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }catch let err{
                        DispatchQueue.main.async {
                            
                            print(err)
                            completion(self.getError(from: err as NSError))
                            
                        }
                    }
                }
            }
        }//end Task
        task.resume()
    }//end async
    }//end calendar day
    
    func getRequests(forUser: String, completion: @escaping ([Request]?, NSError?) ->()){
       
        DispatchQueue.global(qos: .userInteractive).async {
            
            var requests: Array<Request> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/getRequests.php")//?user=" + forUser)
            
            var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(exactly: 10.00)!)
            
            request.httpMethod = "POST"
            
            var postString:String
            
            postString = "user=" + forUser
            
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
                           
                            for request in jdata {
                                
                               
                                
                                
                                
                                
                                let ev = request["0"]! as! Dictionary<String, Any>
                                let events = ev["events"] as! Array<Dictionary<String, String>>
                               //print(events.count)
                                let anEvent = events[0]
                                
                                let thisEvent = Event(anEvent["id"]!, title: anEvent["title"]!, date: anEvent["day"]!, month: anEvent["month"]!, year: anEvent["year"]!, start: anEvent["start"]!, end: anEvent["end"]!, count: "0", creator: anEvent["UID"]!, privacy: anEvent["make_private"]!, allDay: anEvent["allDay"]!)
                                
                                if(request["message"] != nil){
                                    requests.append(Request(request["id"] as! String, e: thisEvent, s: request["sender"] as! String, m: request["message"] as! String))
                                }else{
                                    requests.append(Request(request["id"] as! String, e: thisEvent, s: request["sender"] as! String))
                                }
                           
                            }
                            DispatchQueue.main.async {
                                completion(requests, nil)
                            }
                    }catch let e{
                        
                        DispatchQueue.main.async {
                            completion(nil, self.getError(from: e as NSError))
                        }
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
    }//end getCalMonth
    
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
        
        postString += "&id=" + (AccessToken.current?.userId)!
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
        
        postString += "&uid=" + (AccessToken.current?.userId)!
        
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
    
    func saveNewRequest(event: String, user: String, name: String, isNotMe: Bool){
        
        let url = URL(string: self.BASE_URL + "/calendar/addRequest.php")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        var postString:String
        postString = "eventID=" + event
        
        postString += "&id=" + user
        
        postString += "&sender=" + (AccessToken.current?.userId)!
        
        postString += "&senderName=" + name
        
        postString += "&notMe=" + String(isNotMe)
        //print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            if error != nil {
                print("ERROR")
                print(error!)
            }
        }//end task
        task.resume()
    }//end save request
    
    
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
            
            let url = URL(string: self.BASE_URL + "/calendar/getUserOptions.php?uid=" + forUser)
            
            let token = Messaging.messaging().fcmToken
            
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
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
                            Settings.sharedInstance.uid = jdata["uid"]!
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

            var urlString = self.BASE_URL
            urlString = urlString + "/calendar/updateUserOptions.php?uid=" + settings.uid
            urlString = urlString + "&format=" + String(describing: settings.dateFormat)
            urlString = urlString + "&privacy=" + String(describing: settings.privacy)
            
            let url = URL(string: urlString)
            
            
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
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
        postString += "&poster=" + (AccessToken.current?.userId)!
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
        
        var postString:String
        postString = "token=" + Messaging.messaging().fcmToken!
        
        postString += "&sender=" + (AccessToken.current?.userId)!
        
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
            
            var graph = GraphRequest.init(graphPath: request)
            graph.parameters = ["fields": params]
          //  graph.parameters = nil
            graph.start({ (response, data) in
                
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
                
            })//end request
        }//end async
    }//end doGraph
    
    func getError(from: NSError) ->NSError{
        print("===GETERROR===")
        if(from.domain == "NSCocoaErrorDomain"){
            return NSError(domain: "com.makeitfortheweb", code: 101, userInfo: ["message": "An error occured while accessing the calendar."])
        }else if(from.domain == NSURLErrorDomain && from.code == -1009){
            return NSError(domain: "com.makeitfortheweb", code: 100, userInfo: ["message": "The Internet connection appears to be offline."])
        }else{
            return NSError(domain: "com.makeitfortheweb", code: 001, userInfo: ["message": "An unknown error has occured while maing your request."])
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
                        var statAd = Status(id: nil, poster: nil, message: nil, name: nil, link: nil, comments: nil, isAd: true)
                        statAd.isAd = true
                        
                        stat.insert(statAd, at: index)
                        // print(statuses)
                    }
                }
                index = index + 1
            }while(index <= stat.count)
        }else{
            let statAd = Status(id: nil, poster: nil, message: nil, name: nil, link: nil, comments: nil, isAd: true)
            
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
