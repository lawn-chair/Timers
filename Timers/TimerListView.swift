//
//  TimerListView.swift
//  Timers
//
//  Created by Brent Rahn on 6/21/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI

struct TimerListView: View {
    @ObservedObject var timer: WorkoutTimer
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(timer.name ?? "")")
            HStack {
                Text("Reps: \(timer.reps)").font(.footnote)
                Text("Active: \(timer.activeTime / 60):\(timer.activeTime % 60, specifier: "%02d")").font(.footnote)
                Text("Rest: \(timer.restTime / 60):\(timer.restTime % 60, specifier: "%02d")").font(.footnote)
                Text("Time: \(timer.totalTime / 60):\(timer.totalTime % 60, specifier: "%02d")").font(.footnote)
            }
        }
    }
}

struct TimerListView_Previews: PreviewProvider {
    static var previews: some View {
        TimerListView(timer: WorkoutTimer())
    }
}
