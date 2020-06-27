//
//  Timer+Extensions.swift
//  Timers
//
//  Created by Brent Rahn on 6/20/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import Foundation

extension WorkoutTimer: Identifiable {
    
    var totalTime: Int {
        Int((self.activeTime + self.restTime)) * Int(self.reps)
    }
}
