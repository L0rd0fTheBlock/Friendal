//
//  StatusView.swift
//  CalTest
//
//  Created by Jamie McAllister on 09/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class StatusView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var statuses: [Status] = []
    var event: Event? = nil
    var hasPropogatedAdverts = false
    
    var rootView: EventViewController? = nil
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor(rgb:0xD1D1D1)
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
        
        isPagingEnabled = true
        
        register(StatusViewCell.self, forCellWithReuseIdentifier: "StatusCell")
        register(NewStatusViewCell.self, forCellWithReuseIdentifier: "NewStatusCell")
        register(AdMobCollectionViewCell.self, forCellWithReuseIdentifier: "AdvertStatusCell")
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func doLoad(){
       
        let calHandler = CalendarHandler()
        
       // calHandler.getEventStatus((event?.id)!) { (statuses, error) in
            //do status handling

         /*   guard var status = statuses else{
               
                return
            }
            self.statuses = status
            for (index, var stat) in status.enumerated(){
               // print("line 52:" , stat)
                if(!stat.isAd!){
                    let poster = stat.poster!
                    calHandler.doGraph(request: poster, params: "id, first_name, last_name, middle_name, name, email, picture", completion: {(data, error) in
                        
                        let picture = data!["picture"] as? Dictionary<String, Any>
                        let d = picture!["data"] as! Dictionary<String, Any>
                        let url = d["url"] as! String
                        
                        
                        stat.link = url
                        stat.name = data!["name"] as? String
                        self.statuses[index] = stat
                        self.reloadData()
                    })
                }
            }
            
            
            self.reloadData()
        }*/
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("counting")
        
        return statuses.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("=====INDEX===== ", indexPath.row - 1)
        print("number of statuses: ", statuses.count)
        if(indexPath.row == 0){
            print("creating newStatus")
            let cell = dequeueReusableCell(withReuseIdentifier: "NewStatusCell", for: indexPath) as! NewStatusViewCell
            
           // cell.event = self.event
            
            return cell
        }else{
            if(statuses[indexPath.row - 1].isAd != nil){
                print("not nil: ", statuses[indexPath.row - 1].isAd)
            }else{
                statuses[indexPath.row - 1].isAd = false
                print("was nil - now: ", statuses[indexPath.row - 1].isAd)
            }
            if(statuses[indexPath.row - 1].isAd!){
                print(indexPath.row, ": Is Ad")
                let cell = dequeueReusableCell(withReuseIdentifier: "AdvertStatusCell", for: indexPath) as! AdMobCollectionViewCell
                //cell.rootView = rootView
               // cell.loadBannerView()
                return cell
            }else{
                print(indexPath.row, ": Is Not Ad")
                let cell = dequeueReusableCell(withReuseIdentifier: "StatusCell", for: indexPath) as! StatusViewCell
                
                cell.backgroundColor = .white
                cell.message.text = statuses[indexPath.row - 1].message
                cell.poster.text = statuses[indexPath.row - 1].name
                
                guard let link = statuses[indexPath.row - 1].link else{
                    return cell
                    
                }
                
                let url = URL(string: link)
                
                getDataFromUrl(url: url!, completion: { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        cell.picture.image = UIImage(data: data)!
                    }
                })
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //print ("getting size")
        if(indexPath.row > 0){
            if(statuses[indexPath.row - 1].isAd!){
                print("Ad-Size at: ", indexPath.row)
                return CGSize(width: frame.width, height: frame.height)
            }else{
                return CGSize(width: frame.width, height: frame.height)
            }
        }else{
            return CGSize(width: frame.width, height: frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) ->()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

}
