//
//  Subject.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import Foundation
import RealmSwift

class Subject: Object {
    
    @objc dynamic var day: Int = 0
    @objc dynamic var month: String = ""
    
    @objc dynamic var female: Bool = false
    @objc dynamic var male: Bool = false
    
    @objc dynamic var name: String = ""
    @objc dynamic var nameInfo: String = ""
    @objc dynamic var eventInfo: String = ""
    
    @objc dynamic var dog: Bool = false
    @objc dynamic var cat: Bool = false
    @objc dynamic var human: Bool = false
    @objc dynamic var event: Bool = false
}
