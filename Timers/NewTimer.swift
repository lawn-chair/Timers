//
//  NewTimer.swift
//  Timers
//
//  Created by Brent Rahn on 6/20/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI

struct NewTimer: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    var workout : Workout
    
    @State var name = ""
    @State var reps: Int32 = 1
    @State var activeTime: Int32 = 0
    @State var restTime: Int32 = 0
    
    var body: some View {
        TimerDetailView(name: $name, reps: $reps, activeTime: $activeTime, restTime: $restTime) {
            Button("Add Timer") {
                let timer = WorkoutTimer(context: self.managedObjectContext)
                timer.id = UUID()
                timer.name = self.name
                timer.reps = Int32(self.reps)
                timer.activeTime = Int32(self.activeTime)
                timer.restTime = Int32(self.restTime)
                timer.workout = self.workout
                
                self.workout.lastModified = Date()
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print(error)
                }
                
                // "Go Back" to main list
                self.presentationMode.wrappedValue.dismiss()
                
            }
            
        }
    }
}

struct NewTimer_Previews: PreviewProvider {
    static var previews: some View {
        NewTimer(workout: Workout())
    }
}
