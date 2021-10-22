//
//  AlarmNotification.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 24/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//


import Foundation
import UIKit


class AlarmNotification : TimeDelegate
{
    var alarm: Alarms = Alarms()
    
    func notificationSettings() -> UIUserNotificationSettings {
        var snoozeEnabled: Bool = false
        if let scheduled = UIApplication.shared.scheduledLocalNotifications {
            if let result = activeDate(notifications: scheduled) {
                let num = result.1
                snoozeEnabled = alarm.alarms[num].snoozeEnabled
            }
        }
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.sound]
        
        
        let stopNotification = UIMutableUserNotificationAction()
        stopNotification.identifier = Path.stopIdentifier
        stopNotification.title = "Medicine taken"
        stopNotification.activationMode = UIUserNotificationActivationMode.background
        stopNotification.isDestructive = false
        stopNotification.isAuthenticationRequired = false
        
        let snoozeNotification = UIMutableUserNotificationAction()
        snoozeNotification.identifier = Path.snoozeIdentifier
        snoozeNotification.title = "Snooze"
        snoozeNotification.activationMode = UIUserNotificationActivationMode.background
        snoozeNotification.isDestructive = false
        snoozeNotification.isAuthenticationRequired = false
        
        let actionsArray = snoozeEnabled ? [UIUserNotificationAction](arrayLiteral: snoozeNotification, stopNotification) : [UIUserNotificationAction](arrayLiteral: stopNotification)
        let actionsArrayMinimal = snoozeEnabled ? [UIUserNotificationAction](arrayLiteral: snoozeNotification, stopNotification) : [UIUserNotificationAction](arrayLiteral: stopNotification)
        
        let categoryType = UIMutableUserNotificationCategory()
        categoryType.identifier = "myAlarmCategory"
        categoryType.setActions(actionsArray, for: .default)
        categoryType.setActions(actionsArrayMinimal, for: .minimal)
        
        
        let categoriesForSettings = Set(arrayLiteral: categoryType)
        
        let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: categoriesForSettings)
        UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
        return newNotificationSettings
    }
    
    private func formatDate(_ date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]
    {
        var fDate: [Date] = [Date]()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let f: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
        let dateFormat = (calendar as NSCalendar).components(f, from: date)
        let day:Int = dateFormat.weekday!
        
        
        
        if weekdays.isEmpty{
            //scheduling date is eariler than current date
            if date < now {
                //plus one day, otherwise the notification will be fired righton
                fDate.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!)
            }
            else { //later
                fDate.append(date)
            }
            return fDate
        }
            //repeat
        else {
            let numberOfDays = 7
            fDate.removeAll(keepingCapacity: true)
            for num in weekdays {
                
                var numberDay: Date!
                //schedule on next week
                if dateComparision(days: num, with: day) == .before {
                    numberDay =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: num+numberOfDays-day, to: date, options:.matchStrictly)!
                }
                    //schedule on today or next week
                else if dateComparision(days: num, with: day) == .same {
                    //scheduling date is eariler than current date, then schedule on next week
                    if date.compare(now) == ComparisonResult.orderedAscending {
                        numberDay = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: numberOfDays, to: date, options:.matchStrictly)!
                    }
                    else {
                        numberDay = date
                    }
                } else {
                    numberDay =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: num-day, to: date, options:.matchStrictly)!
                }
                
                numberDay = AlarmNotification.formatNextPart(date: numberDay, calendar: calendar)
                fDate.append(numberDay)
            }
            return fDate
        }
    }
    
    public static func formatNextPart(date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian))->Date {
        let next = calendar.component(.second, from: date)
        let day = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -next, to: date, options:.matchStrictly)!
        return day
    }
    
    internal func prepareNotification(_ date: Date, onWeekdaysForNotify weekdays:[Int], snoozeEnabled:Bool,  onSnooze: Bool, soundName: String, index: Int) {
        let notify: UILocalNotification = UILocalNotification()
        notify.alertBody = "Take your medicine!"
        notify.alertAction = "Open"
        notify.category = "myAlarmCategory"
        notify.soundName = soundName + ".mp3"
        notify.timeZone = TimeZone.current
        let repeating: Bool = !weekdays.isEmpty
        notify.userInfo = ["snooze" : snoozeEnabled, "index": index, "soundName": soundName, "repeating" : repeating]
        //repeat weekly if repeat weekdays are selected
        //no repeat with snooze notification
        if !weekdays.isEmpty && !onSnooze{
            notify.repeatInterval = NSCalendar.Unit.weekOfYear
        }
        
        let datesNotifications = formatDate(date, onWeekdaysForNotify:weekdays)
        
        startTime()
        for dateNotify in datesNotifications {
            
            
            alarm.alarms[index].date = dateNotify
            
            notify.fireDate = dateNotify
            UIApplication.shared.scheduleLocalNotification(notify)
        }
        notificationSettings()
        
    }
    
    func prepareSnoozeNotification(snoozeMinute: Int, soundName: String, index: Int) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: snoozeMinute, to: now, options:.matchStrictly)!
        prepareNotification(snoozeTime, onWeekdaysForNotify: [Int](), snoozeEnabled: true, onSnooze:true, soundName: soundName, index: index)
    }
    
    func newNotification() {
        UIApplication.shared.cancelAllLocalNotifications()
        startTime()
        for num in 0..<alarm.amount{
            let clock = alarm.alarms[num]
            if clock.enabled {
                prepareNotification(clock.date, onWeekdaysForNotify: clock.days, snoozeEnabled: clock.snoozeEnabled, onSnooze: false, soundName: clock.mediaLabel, index: num)
            }
        }
    }
    
    func controlNotification() {
        alarm = Alarms()
        let notification = UIApplication.shared.scheduledLocalNotifications
        if notification!.isEmpty {
            for num in 0..<alarm.amount {
                alarm.alarms[num].enabled = false
            }
        }
        else {
            for (num, clock) in alarm.alarms.enumerated() {
                var oldDate = true
                if clock.onSnooze {
                    oldDate = false
                }
                for notify in notification! {
                    if clock.date >= notify.fireDate! {
                        oldDate = false
                    }
                }
                if oldDate {
                    alarm.alarms[num].enabled = false
                }
            }
        }
    }
    
    private func startTime() {
        alarm = Alarms()
    }
    
    private enum compareDays {
        case before
        case same
        case after
    }
    
    private func dateComparision(days num1:Int, with num2:Int)-> compareDays{
        if num1 != 1 && num2 == 1 {return .before}
        else if num1 == num2 {return .same}
        else {return .after}
    }
    
    private func activeDate(notifications: [UILocalNotification]) -> (Date, Int)? {
        if notifications.isEmpty {
            return nil
        }
        var idDate = -1
        var dateDate: Date = notifications.first!.fireDate!
        for notify in notifications {
            let index = notify.userInfo!["index"] as! Int
            if(notify.fireDate! <= dateDate) {
                dateDate = notify.fireDate!
                idDate = index
            }
        }
        return (dateDate, idDate)
    }
}

