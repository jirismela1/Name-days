//
//  SortNamesToMonths.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import Foundation
import RealmSwift


class SortNamesToMonths{
    
    fileprivate var realmData: Results<Subject>?
    fileprivate var sortData = [[Subject]]()
    
    init(_ data: Results<Subject>) {
        self.realmData = data
        sortData = sortDataName()
    }
}
extension SortNamesToMonths{
    func sortDataName() -> [[Subject]]{
        
        let numberOfMonths = K.months.count
        var arrayMonth = Array(repeating: [Subject](), count: numberOfMonths)
        
        if let sortMonth = realmData{
            if sortMonth.count != 0{
            for month in 0...sortMonth.count - 1{
                    if sortMonth[month].human || sortMonth[month].event{
                       switch sortMonth[month].month{
                        case "January":
                            arrayMonth[0].append(sortMonth[month])
                        case "February":
                            arrayMonth[1].append(sortMonth[month])
                        case "March":
                            arrayMonth[2].append(sortMonth[month])
                        case "April":
                            arrayMonth[3].append(sortMonth[month])
                        case "May":
                            arrayMonth[4].append(sortMonth[month])
                        case "June":
                            arrayMonth[5].append(sortMonth[month])
                        case "July":
                            arrayMonth[6].append(sortMonth[month])
                        case "August":
                            arrayMonth[7].append(sortMonth[month])
                        case "September":
                            arrayMonth[8].append(sortMonth[month])
                        case "October":
                            arrayMonth[9].append(sortMonth[month])
                        case "November":
                            arrayMonth[10].append(sortMonth[month])
                        case "December":
                            arrayMonth[11].append(sortMonth[month])
                        default:
                            break
                        }
                    }
                }
                for month in 0...numberOfMonths - 1{
                    arrayMonth[month].sort {$0.day < $1.day}
                }
            }
           
        }
        
        return arrayMonth
    }
    
    func namesOfToday(month: Int,day: Int) -> [Subject]{
        var arraySubject = [Subject]()
            
        for subject in sortData[month].indices{
            if sortData[month][subject].day == day{
                arraySubject.append(sortData[month][subject])
            }
        }
        return arraySubject
    }
    
    func selectDay(month: Int,day: Int) -> [Subject]{
        var array = [Subject]()
            
        for n in sortData[month].indices{
            if sortData[month][n].day == day{
                array.append(sortData[month][n])
            }
        }
        
        return array
    }
}
