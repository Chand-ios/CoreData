//
//  LocalNotification.swift
//  CoreDataAlarm
//
//  Created by eAlphaMac2 on 14/02/20.
//  Copyright © 2020 eAlphaMac2. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotificationManager
{
    var notifications = [Notification]()


struct Notification {
    var id:String
    var title:String
    var datetime:DateComponents
}
func listScheduledNotifications()
{
    UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

        for notification in notifications {
            print(notification)
        }
    }
}
private func requestAuthorization()
{
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

        if granted == true && error == nil {
            self.scheduleNotifications()
        }
    }
}
func schedule()
{
    UNUserNotificationCenter.current().getNotificationSettings { settings in

        switch settings.authorizationStatus {
        case .notDetermined:
            self.requestAuthorization()
        case .authorized, .provisional:
            self.scheduleNotifications()
        default:
            break // Do nothing
        }
    }
}
private func scheduleNotifications()
{
    for notification in notifications
    {
        let content      = UNMutableNotificationContent()
        content.title    = notification.title
        content.sound    = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

        let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in

            guard error == nil else { return }

            print("Notification scheduled! --- ID = \(notification.id)")
        }
    }
}
}
