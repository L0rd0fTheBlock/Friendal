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
    var eventID: String = "0"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .gray
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
        
        register(StatusViewCell.self, forCellWithReuseIdentifier: "StatusCell")
        register(NewStatusViewCell.self, forCellWithReuseIdentifier: "NewStatusCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func doLoad(){
        print("doLoad called")
        let calHandler = CalendarHandler()
        
        calHandler.getEventStatus(eventID) { (statuses, error) in
            //do status handling
            print("completion Handler: ")
            print(statuses)
            guard var status = statuses else{
               
                return
            }
            
            for var stat in status{
                calHandler.doGraph(request: stat.poster, params: "id, first_name, last_name, middle_name, name, email, picture", completion: {(data, error) in
                    
                    let picture = data!["picture"] as? Dictionary<String, Any>
                    let d = picture!["data"] as! Dictionary<String, Any>
                    let url = d["url"] as! String
                    
                    
                    stat.link = url
                    stat.name = data!["name"] as? String
                    
                    self.statuses.append(stat)
                    self.reloadData()
                })
                
            }
            
            
            self.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statuses.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            let cell = dequeueReusableCell(withReuseIdentifier: "NewStatusCell", for: indexPath)
            return cell
        }else{
            let cell = dequeueReusableCell(withReuseIdentifier: "StatusCell", for: indexPath) as! StatusViewCell
            
            cell.backgroundColor = .white
            cell.message.text = statuses[indexPath.row - 1].message
            cell.poster.text = statuses[indexPath.row - 1].name
            
            let url = URL(string: statuses[indexPath.row - 1].link!)
            
            getDataFromUrl(url: url!, completion: { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    cell.picture.image = UIImage(data: data)!
                }
            })
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 25, height: frame.height)
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) ->()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

}
