//
//  ActiveWorkoutView.swift
//  Timers
//
//  Created by Brent Rahn on 6/21/20.
//  Copyright © 2020 Brent Rahn. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ActiveWorkoutView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var workout: Workout
    
    @State private var displayTime = "0:00"
    @State private var currentTime = 12
    @State private var backgroundColor = Color.green
    
    @State private var timerIndex = 0
    @State private var isRestTime = false
    @State private var isDone = false
    @State private var activeTimer: WorkoutTimer?
    @State private var rep = 1
        
    @State private var audioPlayer: AVAudioPlayer?
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.backgroundColor.edgesIgnoringSafeArea(.all)
                Text(self.displayTime)
                    .font(.custom("Avenir Next Condensed", size: 1000))
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .foregroundColor(Color.white)
                HStack {
                    Text("Rep: \(self.rep)/\(self.activeTimer != nil ? self.activeTimer!.reps : 1)")
                        .foregroundColor(Color.white)
                    Spacer()
                    
                }.offset(y: geometry.size.height / 2 - 20)
                
                HStack {
                    Text("\(self.isDone ? "Workout Complete" : self.isRestTime ? "Rest" : self.activeTimer != nil ? self.activeTimer!.name! : "")")
                        .foregroundColor(Color.white)
                        .bold()
                }.offset(y: geometry.size.height / 2 - 20)
                
                HStack {
                    Image(systemName: "multiply.circle")
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 24))
                    .foregroundColor(Color.white)
                    .padding(.leading, 3)
                    Spacer()
                }.offset(y: -(geometry.size.height / 2 - 15))
                
            }
            .onAppear {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
                
                self.activeTimer = self.workout.timerList[self.timerIndex]
                
                self.currentTime = Int(self.activeTimer!.activeTime)
                
                self.displayTime = String(format: "%d:%02d",
                                          self.currentTime / 60,
                                          self.currentTime % 60)
            }
            .onDisappear {
                DispatchQueue.main.async {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
                    
                    //Stop timer when leaving this view
                    self.timer.upstream.connect().cancel()
                }
            }
            .onReceive(self.timer) { time in
                if self.isDone { return }
                
                self.timerTick()
            }
        }
            
        .navigationBarHidden(true)
        .navigationBarTitle("")
        
    }
    
    private func timerTick() {
        // Count down if we're still above 0
        if(self.currentTime > 0) {
            
            self.currentTime -= 1
            
        } else { // currentTime <= 0
            
            self.isRestTime.toggle()
            // If we're now resting, grab the active timer's rest time
            if self.isRestTime {
                self.currentTime = Int(self.activeTimer!.restTime)
            } else {
                // Finished resting, go on to the next rep of this timer,
                // or start the next timer in the workout, or the workout is complete.
                if self.rep < self.activeTimer!.reps {
                    self.rep = self.rep + 1
                } else {
                    self.timerIndex += 1
                    if self.timerIndex < self.workout.timerList.count {
                        self.rep = 1
                        self.activeTimer = self.workout.timerList[self.timerIndex]
                    } else {
                        
                        self.isDone = true
                        self.workout.lastUsed = Date()
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                        
                        return
                    }
                }
                
                // reset currentTime to our new starting value
                self.currentTime = Int(self.activeTimer!.activeTime)
            }
        }
        
        self.displayTime = String(format: "%d:%02d",
                                  self.currentTime / 60,
                                  self.currentTime % 60)
        
        // Play beep for last 3 seconds of active timer, but not rest time
        if self.currentTime <= 3 && self.currentTime > 0 && !self.isRestTime {
            self.audioPlayer = try? AVAudioPlayer(data: NSDataAsset(name:"beep1")!.data , fileTypeHint: "mp3")
            self.audioPlayer?.play()
        }
        
        // Flash background yellow for last 3 seconds.
        if self.currentTime == 3 || self.currentTime == 1 {
            self.backgroundColor = Color.yellow
        } else if self.currentTime == 0 {
            self.audioPlayer = try? AVAudioPlayer(data: NSDataAsset(name:"beep2")!.data , fileTypeHint: "mp3")
            self.audioPlayer?.play()
            
            self.backgroundColor = Color.red
        } else {
            self.backgroundColor = self.isRestTime ? Color.red : Color.green
        }
    }
}

struct ActiveWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let workout = SeedData().workout()

        return ActiveWorkoutView(workout: workout)
            .environment(\.managedObjectContext, context)
            .previewLayout(PreviewLayout.fixed(width: 896, height: 414))
    }
}

