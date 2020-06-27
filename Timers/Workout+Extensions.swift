//
//  Workout+Extensions.swift
//  Timers
//
//  Created by Brent Rahn on 6/20/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import Foundation

extension Workout : Identifiable {
    
    var timerList: [WorkoutTimer] {
        return (timers?.array as? [WorkoutTimer]) ?? []
    }
    
}
