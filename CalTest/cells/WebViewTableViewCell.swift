//
//  WebViewTableViewCell.swift
//  CalTest
//
//  Created by Jamie McAllister on 01/01/2018.
//  Copyright © 2018 Jamie McAllister. All rights reserved.
//

import UIKit

class WebViewTableViewCell: UITableViewCell {

    var table: SettingsViewController?
    let btn = UIButton()
    let webView = BugReportViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        btn.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        btn.setTitle("Report a bug or request a feature  >", for: .normal)
        btn.setTitleColor(UIColor.black , for: .normal)
        
        btn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        addSubview(btn)
        
        print("subViewAdded")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc
    func didTapButton(){
        let nav = CalendarNavigationController(rootViewController: webView)
        nav.title = "Bug Report"
        table?.navigationController?.present(nav, animated: true, completion: nil)
        
    }

}
