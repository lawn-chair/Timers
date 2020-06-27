//
//  TimerPicker.swift
//  Timers
//
//  Created by Brent Rahn on 6/20/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI

struct TimerPickerEdit: View {
    @Binding var duration: Int32
    var label: String
    
    @State var minutes: Int = 0
    @State var seconds: Int = 0 
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    Picker(selection: self.$minutes, label: Text("")) {
                        ForEach(0 ..< 91) { i in
                            Text(String(i)).tag(i)
                        }
                    }.frame(width: geometry.size.width / 2, height: geometry.size.height)
                        .clipped()
                    
                    Picker(selection: self.$seconds, label: Text("")) {
                        ForEach(0 ..< 60) { i in
                            Text(String(i)).tag(i)
                        }
                    }.pickerStyle(WheelPickerStyle())
                        .frame(width: geometry.size.width / 2, height: geometry.size.height)
                        .clipped()
                    
                }
                /* Hack to use minutes and seconds with a single duration input/output */
                .onAppear {
                    self.minutes = Int(self.duration / 60)
                    self.seconds = Int(self.duration % 60)
                }.onDisappear {
                    self.duration = Int32(self.minutes * 60 + self.seconds)
                }
                .navigationBarTitle(self.label)
                
                Text("min").fontWeight(.bold)
                    .offset(x: -geometry.size.width / 8)
                Text("sec").fontWeight(.bold)
                    .offset(x: geometry.size.width / 8 + geometry.size.width / 4)
                
                
            }
        }
    }
}

struct TimerPicker: View {
    var label: String
    @Binding var duration: Int32
    
    var minutes: Int32 {
        self.duration / 60
    }
    var seconds: Int32 {
        self.duration % 60
    }
    
    var body: some View {
        HStack {
            NavigationLink(destination: TimerPickerEdit(duration: self.$duration, label: label)) {
                Text(label).foregroundColor(.primary)
                Spacer()
                Text("\(self.minutes):\(self.seconds, specifier: "%02d")").foregroundColor(Color.gray)
            }
        }
        .navigationBarTitle(Text(label))
        
    }
}

struct TimerPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TimerPicker(label: "Test", duration: .constant(75))
        }
    }
}
