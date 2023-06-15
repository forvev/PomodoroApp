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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> //to change the button
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pomodoro.cycles, ascending: true)], animation: .default)
    private var pomodoroList : FetchedResults<Pomodoro>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Bloom.stageInt, ascending: true)],
                  animation: .default)
    private var bloomList: FetchedResults<Bloom>
    
    @State var timeRemaining: TimeInterval = 2 // 25 minutes in seconds
    @State var isPressed: Bool = false
    @Binding var currentPomodoro: Pomodoro?
    @State private var chosenBloom: Bloom?
    @State private var isPopupPresented = false
    @State private var navigate = false
        
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var formattedTimeRemaining: String {
            let minutes = Int(timeRemaining) / 60
            let seconds = Int(timeRemaining) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    
    var btnBack : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack{
                    Text("Back")
                    Image(systemName: "arrowshape.backward")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
        
    var body: some View {
            ZStack{
                Color(red: 0.621, green: 0.27, blue: 0.343)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    
                    if (currentPomodoro == nil){
                        Text("You have to provide the goal or choose it from the list!")
                    }else{
                        VStack{
                            Text("Your current goal: \(currentPomodoro?.goal ?? "")")
                            Text("Cycles: \(currentPomodoro?.cycles ?? 0)")
                            Text("Bloom's stage: \(currentPomodoro?.toBloom?.stage ?? "")")
                            
                        }.font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0.521, green: 0.27, blue: 0.343))
                            .cornerRadius(8)
                    }
                
                    
                    Text("Time remaining: \(formattedTimeRemaining)")
                        .onReceive(timer) { _ in
                            if (timeRemaining > 0 && isPressed == true){
                                timeRemaining -= 1
                            }
                            else if(timeRemaining == 0){
                                timeRemaining = 2
                                addValueToClock() //add 1 to the cycles
                                isPressed = false // if time is over wait for a user to press the button
                            }
                        }
                        .font(.largeTitle)
                    
                    //if the pomodoro isn't created a user has to choose the pomodoro's goal
                    if(currentPomodoro != nil)
                    {
                        Button{
                            isPressed.toggle()
                        }label:{
                            if(isPressed == true){
                                Image(systemName: "pause")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            else{
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                    
                    Spacer()
                    
                }
                ZStack{
                    if (currentPomodoro != nil){
                        Button{
                            chosenBloom = currentPomodoro?.toBloom
                            isPopupPresented = true
                        }label:{
                            Text("Change Stage")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .offset(x: -UIScreen.main.bounds.width * 0, y: UIScreen.main.bounds.height * 0.4)                     }
                    if(isPopupPresented){
                        VStack{
                            Picker(selection: $chosenBloom, label: Text("Choose the level of Bloom")) {
                                ForEach(bloomList, id: \.self) { bloom in
                                    Text(bloom.stage!).tag(bloom as Bloom?)
                                }
                            }
                            HStack{
                                Button("Save"){
                                    changeMyBloom()
                                    isPopupPresented = false
                                    navigate = true
                                }.padding()
                                NavigationLink(destination: BloomStatus(),isActive: $navigate){
                                    EmptyView()
                                }
                                        
                                Button("Cancel"){
                                    isPopupPresented = false
                                }.padding()
                            }
                        }
                        .frame(width: 200, height:150)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding()
                    }
                }
        
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack, trailing:
                                    HStack {
                                        Spacer()
                                        NavigationLink(
                                            destination: BloomStatus(),
                                            label: {
                                                HStack{
                                                    Text("Summary")
                                                    Image(systemName: "book")
                                                }.font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .background(Color.blue)
                                                    .cornerRadius(8)
                                                
                                            })
                                    })
        
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
    
    private func addValueToClock(){
        currentPomodoro?.cycles += 1
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func changeMyBloom(){
        //var my_number = 0
        //var my_string = currentPomodoro?.toBloom?.stage ?? ""
        //currentPomodoro?.toBloom?.stage ?? ""
        //print("my str: \(my_string)")
        guard let currentPomodoro = currentPomodoro else {return}
        currentPomodoro.toBloom = chosenBloom
        //currentPomodoro?.toBloom?.stageInt = Int16(chosenBloom?.stageInt ?? 0)
        do{
            try viewContext.save()
        }catch{
            print("Failed to save")
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

//struct ClockView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClockView()
//    }
//}
