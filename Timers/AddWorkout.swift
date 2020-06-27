//
//  AddWorkout.swift
//  Timers
//
//  Created by Brent Rahn on 6/20/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI

struct AddWorkout: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var workoutName = ""
    //@State var timers: [Timer] = []
    
    
    var body: some View {
        Form {
            VStack {
                TextField("Workout Name", text: self.$workoutName)
                    .padding()
                
                HStack {
                    Button("Add Workout") {
                        let workout = Workout(context: self.managedObjectContext)
                        workout.id = UUID()
                        workout.name = self.workoutName
                        workout.lastModified = Date()
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                        
                        // "Go Back" to main list
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    Spacer()
                }
            }
        }.navigationBarTitle("New Workout", displayMode: .inline)
    }
}

struct AddWorkout_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkout()
    }
}
