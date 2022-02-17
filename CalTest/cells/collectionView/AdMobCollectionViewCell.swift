//
//  AdMobCollectionViewCell.swift
//  CalTest
//
//  Created by MakeItForTheWeb Ltd. on 11/01/2018.
//  Copyright © 2018 MakeItForTheWeb Ltd.. All rights reserved.
//

import UIKit
//import GoogleMobileAds

class AdMobCollectionViewCell: UICollectionViewCell {
   /* var rootView: EventViewController? = nil
    
    var bannerView: GADBannerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // In this case, we instantiate the banner with desired ad size.
        backgroundColor = .white
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        bannerView.adUnitID = "ca-app-pub-8694139400395039/9086600880"
        guard let root = rootView else{return}
       loadBannerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bannerView)
        bannerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        bannerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
    
    func loadBannerView(){
        guard let root = rootView else{return}
        bannerView.rootViewController = root
        let request = GADRequest()
        request.keywords = root.event?.title?.components(separatedBy: " ")
        request.testDevices = [ "097f2bd01e3ae4cb682ef8477dcb32a7" ]
        bannerView.load(request)
        addBannerViewToView(bannerView)
    }*/
    
}
