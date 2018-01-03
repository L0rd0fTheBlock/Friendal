//
//  CalendarHandler.swift
//  CalTest
//
//  Created by Jamie McAllister on 19/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import Foundation
import FacebookCore

class CalendarHandler{
    
    let BASE_URL = "http://90.221.83.199"
    //let BASE_URL = "http://192.168.0.67"
    
    func getCalMonth(forMonth: String, ofYear: String, withUser: String, completion: @escaping ([CalendarDay], String) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            
            var month: Array<CalendarDay> = []
            var m = ""
            let url = URL(string: self.BASE_URL + "/calendar/getmonth.php?month=" + forMonth  + "&year=" + ofYear + "&user=" + withUser)
            print(url?.absoluteString)
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
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
                                    let thisDay = CalendarDay(onDay: day["date"] as! String, ofMonth: day["month"] as! String, hasEvent: hasEvent)
                                    
                                    if(hasEvent){
                                        for event in day["Events"] as! Array<[String: String]> {
                                            thisDay.addEvent(event: Event(event["id"]!, title: event["title"]!, date: event["day"]!, month: event["month"]!, year: event["year"]!, start: event["start"]!, end: event["end"]!, count: event["inviteCount"]!, creator: event["UID"]!, privacy: event["make_private"]!, allDay: event["allDay"]!))
                                        }
                                    }
                                    month.append(thisDay)
                                }
                                DispatchQueue.main.async {
                                    completion(month, m)
                                }
                            }catch{
                                
                            }
                        }
                    }
            }//end Task
            task.resume()
        }//end async
    }//end getCalMonth
    
    func getRequests(forUser: String, completion: @escaping ([Request]) ->()){
       
        DispatchQueue.global(qos: .userInteractive).async {
            
            var requests: Array<Request> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/getRequests.php?user=" + forUser)
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                    if let content = data{
                        
                        do{
                            //Array
                            let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                           
                            let jdata = json as! Array<[String: Any]>
                           
                            for request in jdata {
                                
                               
                                
                                
                                
                                
                                let ev = request["0"]! as! Dictionary<String, Any>
                                let events = ev["events"] as! Array<Dictionary<String, String>>
                                let anEvent = events[0]
                                print(anEvent)
                                let thisEvent = Event(anEvent["id"]!, title: anEvent["title"]!, date: anEvent["day"]!, month: anEvent["month"]!, year: anEvent["year"]!, start: anEvent["start"]!, end: anEvent["end"]!, count: "0", creator: anEvent["UID"]!, privacy: anEvent["make_private"]!, allDay: anEvent["allDay"]!)
                                
                                if(request["message"] != nil){
                                    requests.append(Request(request["id"] as! String, e: thisEvent, s: request["sender"] as! String, m: request["message"] as! String))
                                }else{
                                    requests.append(Request(request["id"] as! String, e: thisEvent, s: request["sender"] as! String))
                                }
                           
                            }
                            DispatchQueue.main.async {
                                completion(requests)
                            }
                    }catch let e{
                         //  print("Error")
                            print(e)
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
    }//end getCalMonth
    
    func cancelEvent(event: String, forUser:String, completion:@escaping (_ respond:Bool)->()){
        DispatchQueue.global(qos: .userInteractive).async {
        let url = URL(string: self.BASE_URL + "/calendar/cancelEvent.php?id=" + forUser + "&eid=" + event)
            
        let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
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
                print("Ready for completion: New Event")
                completion(String(data: data!, encoding: String.Encoding.utf8)!)
            }
        }//end task
        task.resume()
    }//end save Event
    
    func saveNewRequest(event: String, user: String){
        
        let url = URL(string: self.BASE_URL + "/calendar/addRequest.php")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        var postString:String
        print(event)
        postString = "eventID=" + event
        
        postString += "&id=" + user
        
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
    
    
    func acceptRequest(_ id: String){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            
             let url = URL(string: self.BASE_URL + "/calendar/acceptRequest.php?id=" + id)
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                }
            }
            task.resume()
        }
    }
    
    func declineRequest(_ id: String){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            
             let url = URL(string: self.BASE_URL + "/calendar/declineRequest.php?id=" + id)
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                }
            }
            task.resume()
        }
    }
    
    func getGoing(forEvent: String, completion: @escaping ([Invitee]) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            print("GETTING GOING")
            var invitees: Array<Invitee> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/getGoing.php?id=" + forEvent)
            
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
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
                                completion(invitees)
                            }
                        }catch{
                            
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
    }//end getGoing
    
    func isInvitee(_ user: String, forEvent: String, completion: @escaping (Bool) ->()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            print("GETTING IS INVITEE")
            var invitees: Array<Invitee> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/isInvitee.php?eid=" + forEvent + "&uid=" + user)
            print(url?.absoluteString)
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                    
                    if let content = data{
                        do{
                            
                            //Array
                            let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                            
                            //print(json)
                            
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
    
    func getNotGoing(forEvent: String, completion: @escaping ([Invitee]) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            
            print("GETTING  NOT GOING")
            
            var invitees: Array<Invitee> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/getNotGoing.php?id=" + forEvent)
            
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
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
                                completion(invitees)
                            }
                        }catch{
                            
                        }
                    }
                }
            }//end Task
            task.resume()
        }//end async
    }//end getNotGoing
    
    func getInvited(forEvent: String, completion: @escaping ([Invitee]) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            
            print("GETTING INVITED")
            
            var invitees: Array<Invitee> = []
            
            let url = URL(string: self.BASE_URL + "/calendar/getInvited.php?id=" + forEvent)
            
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
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
                                completion(invitees)
                            }
                        }catch{
                            
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
            
            let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil {
                    print("ERROR")
                    print(error!)
                }else{
                    
                    if let content = data{
                        do{
                            print(content)
                            //Array
                            let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                          //  print(json)
                            let jdata = json as! Dictionary<String, String>
                            
                            Settings.sharedInstance.id = Int(jdata["id"]!)
                            Settings.sharedInstance.uid = jdata["uid"]!
                            Settings.sharedInstance.dateFormat = Int(jdata["date_format"]!)!
                            Settings.sharedInstance.privacy = Int(jdata["default_privacy"]!)!
                            
                            //print(jdata)

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
            
            print(url?.absoluteString)
            
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
    
    
    func doGraph(request: String, params: String, completion: @escaping (Dictionary<String, Any>) ->()){
        DispatchQueue.global(qos: .userInteractive).async {
            
            var graph = GraphRequest.init(graphPath: request)
            graph.parameters = ["fields": params]
          //  graph.parameters = nil
            graph.start({ (response, data) in
                
                switch data {
                    
                case .success(let d):
                    DispatchQueue.main.async {
                        
                        completion(d.dictionaryValue!)
                    }
                    
                case .failed(let e):
                    print(e)
                }//end switch
                
            })//end request
        }//end async
    }//end doGraph

    
}//end class
