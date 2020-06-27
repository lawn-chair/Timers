//
//  TimerView.swift
//  Timers
//
//  Created by Brent Rahn on 6/21/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI

func ??<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
  return Binding(get: {
    binding.wrappedValue ?? fallback
  }, set: {
    binding.wrappedValue = $0
  })
}

struct TimerView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var timer : WorkoutTimer
    
    var body: some View {
        TimerDetailView(name: self.$timer.name ?? "", reps: self.$timer.reps, activeTime: self.$timer.activeTime, restTime: self.$timer.restTime) {
            Button("Update Timer") {
                self.timer.workout!.lastModified = Date()

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

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let t = WorkoutTimer(context: context)
        t.id = UUID()
        t.name = "Timer 1"
        t.reps = 3
        t.activeTime = 60
        t.restTime = 10
        
        return TimerView(timer: t)
            .environment(\.managedObjectContext, context)
    }
}
