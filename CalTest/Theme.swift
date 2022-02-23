//
//  Theme.swift
//  CalTest
//
//  Created by Andrew McAllister on 18/06/2021.
//  Copyright © 2021 MakeItForTheWeb Ltd. All rights reserved.
//

import UIKit

/*
 
 The purpose of this file is to create colours that can be used within Palendar
 
 It should not be used for anything else.
 
 Any other functions extending UIColor should be placed inside the Extensions.swift file
 
 
 */

extension UIColor{
    public static var nav = UIColor(rgb: 0x33B0Df)
    public static var event = UIColor(rgb: 0x33B0Df)
    public static var eventBorder = UIColor(rgb: 0x2EA4CF)
    public static var day = UIColor(rgb: 0x26be2d)
    public static var allDay = UIColor.darkGray
    public static var today = UIColor.lightGray
}
