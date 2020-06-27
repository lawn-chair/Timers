//
//  EditWorkout.swift
//  Timers
//
//  Created by Brent Rahn on 6/20/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI

struct WorkoutView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
     @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var workout: Workout
    
    @State var workoutName = ""
    @State private var editMode = false
    
    @State private var startWorkout = false
    
    var body: some View {
        Form {
            Section {
                VStack {
                    TextField("Workout Name", text: self.$workoutName)
                        .padding()
                        .disabled(!editMode)
                        .onAppear {
                            self.workoutName = self.workout.name ?? ""
                    }
                }
            }
            
            if !editMode {
                Section(header: Text("Timers")) {
                    List {
                        ForEach(self.workout.timerList) { timer in
                            TimerListView(timer: timer)
                        }
                    }
                }
            } else {
                Section(header: Text("Timers"),
                        footer:
                    NavigationLink( destination: NewTimer(workout: workout)) { Text("Add Timer") })
                {
                    List {
                        ForEach(self.workout.timerList) { timer in
                            NavigationLink(destination: TimerView(timer: timer)) {
                                TimerListView(timer: timer)
                            }
                        }.onDelete { (indexSet) in
                            let toDelete = self.workout.timers![indexSet.first!] as! WorkoutTimer
                            self.managedObjectContext.delete(toDelete)
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            
            if !editMode {
                Button("Start Workout") {
                    print("Starting workout...")
                    self.startWorkout = true
                }
            }
        }
        .sheet(isPresented: $startWorkout)
        {
            ActiveWorkoutView(workout: self.workout)
        }
        .navigationBarTitle(Text(self.workout.name ?? ""), displayMode: .inline)
        .navigationBarItems(trailing: self.editMode ? Button("Save") {
            self.workout.name = self.workoutName
            self.workout.lastModified = Date()
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
            }
            
            self.editMode = false
            } :
            Button("Edit") {
                self.editMode = true
            }
        )
            
        
    }
}

struct EditWorkout_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let workout = SeedData().workout()
        
        return WorkoutView(workout: workout)
            .environment(\.managedObjectContext, context)
    }
}
