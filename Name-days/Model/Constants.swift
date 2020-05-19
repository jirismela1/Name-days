//
//  Constants.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

fileprivate enum DaysInWeek: String{
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

struct K {
    static let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    static let daysShortcut = ["Mo", "Tu", "We", "Th", "Fr", "Sa","Su"]
    
    static let monthsCZ = ["Leden","Únor","Březen","Duben","Květen","Červen","Červenec","Srpen","Září","Říjen","Listopad","Prosinec"]
    static let daysShortcutCZ = ["Po","Út","St","Čt","Pá","So","Ne"]
    
    static let searchTitle = ["Search items"]
    
    static let myRedColor = hexStringToUIColor(hex: "#E23E57")
    static let myRoseColor = hexStringToUIColor(hex: "#88304E")
    static let myDarkRoseColor = hexStringToUIColor(hex: "#522546")
    static let myDarkRed = hexStringToUIColor(hex: "#311D3F")

    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func returnTodayDate(indexDay: Int, day: Int, month: String, year: Int) -> String{
        // indexDay express column in calendar
           switch indexDay{
           case 0,7,14,21,28:
               return "\(DaysInWeek.Monday.rawValue) \(day) \(month) \(year)"
           case 1,8,15,22,29:
               return "\(DaysInWeek.Tuesday.rawValue) \(day) \(month) \(year)"
           case 2,9,16,23,30:
               return "\(DaysInWeek.Wednesday.rawValue) \(day) \(month) \(year)"
           case 3,10,17,24,31:
               return "\(DaysInWeek.Thursday.rawValue) \(day) \(month) \(year)"
           case 4,11,18,25,32:
               return "\(DaysInWeek.Friday.rawValue) \(day) \(month) \(year)"
           case 5,12,19,26,33:
               return "\(DaysInWeek.Saturday.rawValue) \(day) \(month) \(year)"
           case 6,13,20,27,34:
               return "\(DaysInWeek.Sunday.rawValue) \(day) \(month) \(year)"
           default:
               return "Error date"
           }
       }
}
