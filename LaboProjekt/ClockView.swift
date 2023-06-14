//
//  ClockView.swift
//  LaboProjekt
//
//  Created by Artur Zelik on 11/06/2023.
//  Copyright © 2023 student. All rights reserved.
//

import SwiftUI

struct ClockView: View {
    @Environment (\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pomodoro.cycles, ascending: true)], animation: .default)
    private var pomodoroList : FetchedResults<Pomodoro>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Bloom.stage, ascending: true)],
                  animation: .default)
    private var bloomList: FetchedResults<Bloom>
    
    @State var startDate : Date = Date()
    @State var timeRemaining: TimeInterval = 1500 // 25 minutes in seconds
    @State var isPressed: Bool = false
        
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var formattedTimeRemaining: String {
            let minutes = Int(timeRemaining) / 60
            let seconds = Int(timeRemaining) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
    var body: some View {
            ZStack{
                Color(red: 0.621, green: 0.27, blue: 0.343)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    NavigationLink(
                        destination: BloomStatus(),
                        label: {
                            Text("Go to the summary")
                                .frame(width: 100)
                                .border(Color.gray)
                        })
                    
                    Text("Time remaining: \(formattedTimeRemaining)")
                        .onReceive(timer) { _ in
                            if (timeRemaining > 0 && isPressed == true){
                                timeRemaining -= 1
                            }
                        }
                        .font(.largeTitle)
                    
                    Button{
                        isPressed.toggle()
                    }label:{Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    Text("my text: \(pomodoroList.count)")
                }
            }
    }
    
    private func deletePomodoro(offsets: IndexSet) {
        withAnimation {
            offsets.map { pomodoroList[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//struct ClockView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClockView()
//    }
//}
