//
//  PendingNotification.swift
//  LocalNotificationTimerApp
//
//  Created by Tiffany Obi on 2/24/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification{
    
    public func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(" there are \(requests.count) pending requests")
            completion(requests)
        }
    }
}
