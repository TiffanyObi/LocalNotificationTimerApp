//
//  TimerStruct.swift
//  LocalNotificationTimerApp
//
//  Created by Tiffany Obi on 2/24/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

struct StopWatch {

var totalSeconds: Int

var hours: Int {
    return (totalSeconds % 86400) / 3600
}

var minutes: Int {
    return (totalSeconds % 3600) / 60
}

var seconds: Int {
    return totalSeconds % 60
}
    
}

