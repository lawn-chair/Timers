//
//  ContentView.swift
//  Timers
//
//  Created by Brent Rahn on 6/19/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // Access the @Environment's managedObjectContext variable
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Workout.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Workout.timesUsed, ascending: false),
        NSSortDescriptor(keyPath: \Workout.lastUsed, ascending: false),
        NSSortDescriptor(keyPath: \Workout.lastModified, ascending: false)
    ]) var workouts: FetchedResults<Workout>
    
    var body: some View {
        NavigationView {
            List() {
                ForEach(self.workouts) { workout in
                    WorkoutListView(workout: workout)
                }.onDelete { (indexSet) in
                    let toDelete = self.workouts[indexSet.first!]
                    self.managedObjectContext.delete(toDelete)
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
                }
            .navigationBarTitle("Workouts")
            .navigationBarItems(trailing: NavigationLink(destination: AddWorkout()) {
                Image(systemName: "plus").imageScale(.large)
            })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
}
