//
//  LocalNotifications.swift
//  EventsManager
//
//  Created by Ashrita Raman on 5/6/19.
//  Copyright © 2019 Jagger Brulato. All rights reserved.
//

import UIKit
import UserNotifications

/**
 Manages local notifications.
 `EVENT_UPDATED_ID`: An event updated notification is to have the identifier with this as prefix to the pk value.
 `center`: Reference to notification center.
 `options`: The ways in which notifications will be presented to the user.
 */
class LocalNotifications: NSObject, UNUserNotificationCenterDelegate
{
    static let EVENT_UPDATED_ID = "change"
    static let center = UNUserNotificationCenter.current()
    static let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    let window:UIWindow
    
    init(window:UIWindow)
    {
        self.window = window
    }
    /**
     Ask user for permission to send notifications.
     */
    static func requestPermissionForNotifications()
    {
        center.requestAuthorization(options: options)
        {
            (granted, error) in
            if !granted
            {
                print("Notification permissions error")
            }
        }
    }
    /**
     Send a notification for orientation events that were updated.
     - paramter updatedEvents: Names of events that were updated. These event names will be displayed in the notification.
     */
    static func addNotification(for updatedEvents:[Event])
    {
        guard !updatedEvents.isEmpty else {
            return
        }
        
        updatedEvents.forEach({
            let content = UNMutableNotificationContent()
            content.title = "\"\($0.eventName)\" has been updated"
            let request = UNNotificationRequest(identifier: "change\($0.id)", content: content, trigger: nil)
            center.add(request, withCompletionHandler: nil)
        })
    }
    
    /**
     Removes notifications for the given event.
     - parameter eventPk: Pk of event to remove notifications for.
     */
    static func removeNotification(for eventPk: Int)
    {
        center.removePendingNotificationRequests(withIdentifiers: [String(eventPk)])
    }
    
    /**
     Creates a notification for the given event, setting up its time according to saved preferences. Assumes that user has reminders turned on.
     - parameter event: Event to create notifications for.
     */
    static func createNotification(for event: Event)
    {
        let notifyMeTime = UserData.getReminderTime()
        let content = UNMutableNotificationContent()
        content.title = event.eventName
        content.sound = UNNotificationSound.default
        
        //componentsForTrigger.hour = event.startTime.hour
        //componentsForTrigger.minute = event.startTime.minute
        
        var date = DateComponents()
        date.minute = notifyMeTime
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        let request = UNNotificationRequest(identifier: String(event.id), content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    
    /**
     Catches local notifications while app is open and displays them.
     - parameters:
     - center: Same as global variable.
     - notification: The notification that will be shown.
     - completionHandler: Function to run asynchronously (I think).
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // Play sound and show alert to the user
        //TODO don't do this for category updates
        completionHandler([.alert,.sound])
    }
}
