//
//  WorkoutListView.swift
//  Timers
//
//  Created by Brent Rahn on 6/19/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI

struct WorkoutListView: View {
    @ObservedObject var workout: Workout
    
    var body: some View {
        HStack {
            NavigationLink(destination: WorkoutView(workout: workout)) {
                Text(workout.name ?? "Default Workout")
            }
            
        }
    }
}
/*
struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView()
    }
}
*/
