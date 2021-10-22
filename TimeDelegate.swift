//
//  TimeDelegate.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 24/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//

import Foundation
import UIKit

protocol TimeDelegate {
    func prepareNotification(_ date: Date, onWeekdaysForNotify:[Int], snoozeEnabled: Bool, onSnooze:Bool, soundName:String, index: Int)
    func prepareSnoozeNotification(snoozeMinute: Int, soundName: String, index: Int)
    func notificationSettings() -> UIUserNotificationSettings
    func newNotification()
    func controlNotification()
    
}















