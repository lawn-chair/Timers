//
//  TimerDetailView.swift
//  Timers
//
//  Created by Brent Rahn on 6/21/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI

struct TimerDetailView<Content: View>: View {
    @Binding var name: String
    @Binding var reps: Int32
    @Binding var activeTime: Int32
    @Binding var restTime: Int32
    
    let viewContent: () -> Content

    var body: some View {
        Form {
            TextField("Name", text: $name)
            Stepper(value: $reps, in: 0 ... Int32.max) {
                Text("Reps")
                Spacer()
                Text("\(self.reps)")
            }
            TimerPicker(label: "Active Time", duration: $activeTime)
            TimerPicker(label: "Rest Time", duration: $restTime)
            
            viewContent()
        }
    }
}

struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerDetailView(name: .constant(""), reps: .constant(1), activeTime: .constant(0), restTime: .constant(0)) {Text("Nothing")}
    }
}
