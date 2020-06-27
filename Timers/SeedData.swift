//
//  SeedData.swift
//  Timers
//
//  Created by Brent Rahn on 6/27/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

public class SeedData {
    let context:  NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.deleteAll()
        self.seedWorkouts()
    }
    
    func seedWorkouts() {
        for i in 1...3 {
            let workout = Workout(context: self.context)
            workout.name = "Workout \(i)"
            workout.id = UUID()
            workout.lastModified = Date()
            
            for t in 1...2 {
                let timer = WorkoutTimer(context: self.context)
                timer.name = "Timer \(t)"
                timer.id = UUID()
                timer.activeTime = 10
                timer.restTime = 4
                timer.reps = 3
                timer.lastModified = Date()
                
                workout.addToTimers(timer)
            }
            
            do {
                try self.context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func workout() -> Workout {
        let workout = Workout(context: self.context)
        workout.name = "Demo"
        workout.id = UUID()
        workout.lastModified = Date()
        
        let timer = WorkoutTimer(context: self.context)
        timer.name = "Demo Timer"
        timer.id = UUID()
        timer.activeTime = 5
        timer.restTime = 3
        timer.reps = 2
        timer.lastModified = Date()
        
        workout.addToTimers(timer)

        return workout
    }
    
    func deleteAll() {
        let fetchWorkouts = NSFetchRequest<NSFetchRequestResult> (entityName: "Workout")
        let deleteWorkouts = NSBatchDeleteRequest(fetchRequest: fetchWorkouts)
        
        let fetchTimers = NSFetchRequest<NSFetchRequestResult> (entityName: "WorkoutTimer")
        let deleteTimers = NSBatchDeleteRequest(fetchRequest: fetchTimers)
        
        do {
            try self.context.execute(deleteWorkouts)
            try self.context.execute(deleteTimers)
        } catch {
            print(error)
        }
    }
}
