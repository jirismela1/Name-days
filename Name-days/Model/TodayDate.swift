//
//  TodayDate.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import Foundation

class TodayDate{
    var month = Int()
    var day = Int()
    var year = Int()
    
    init(_ day: Int,_ month: Int,_ year: Int) {
        self.month = month
        self.day = day
        self.year = year
    }
}
