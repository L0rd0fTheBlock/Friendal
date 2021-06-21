//
//  Theme.swift
//  CalTest
//
//  Created by Jamie McAllister on 18/06/2021.
//  Copyright © 2021 Jamie McAllister. All rights reserved.
//

import UIKit

extension UIColor{
    public static var nav = UIColor(rgb: 0x33B0Df)
    public static var event = UIColor(rgb: 0x33B0Df)
    public static var eventBorder = UIColor(rgb: 0x2EA4CF)
    public static var day = UIColor(rgb: 0x26be2d)
    public static var allDay = UIColor.darkGray
    public static var today = UIColor.lightGray
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
           assert(red >= 0 && red <= 255, "Invalid red component")
           assert(green >= 0 && green <= 255, "Invalid green component")
           assert(blue >= 0 && blue <= 255, "Invalid blue component")
           assert(alpha >= 0 && alpha <= 1)

           self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
       }

       convenience init(rgb: Int) {
           self.init(
               red: (rgb >> 16) & 0xFF,
               green: (rgb >> 8) & 0xFF,
               blue: rgb & 0xFF,
                alpha: 1
           )
       }
    convenience init(rgb: Int, alpha: CGFloat) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
}
