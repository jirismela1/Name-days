//
//  NotificationManager.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import Foundation
import UserNotifications
import RealmSwift

class NotificationManager: NSObject{
    
    private let notificationCenter = UNUserNotificationCenter.current()
    var notificaton: MyNotificaton?
 
    private func requestAuthorization(){
        notificationCenter.requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            if granted == true && error == nil{
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule(){
        notificationCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus{
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    
    private func scheduleNotifications(){
            guard let notific = self.notificaton else {return}
            let content = UNMutableNotificationContent()
            content.title = notific.title
            content.body = "Don't forget to look at today Namedays."
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notific.datetime, repeats: true)
            
            let request = UNNotificationRequest(identifier: notific.id, content: content, trigger: trigger)
            
            self.notificationCenter.add(request) { (error) in
                guard error == nil else {return}
                print("Notification scheduled! --- ID = \(notific.id)")
            }
    }
}
