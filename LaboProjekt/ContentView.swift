//
//  ContentView.swift
//  LaboProjekt
//
//  Created by student on 06/06/2022.
//  Copyright © 2022 student. All rights reserved.
//

import SwiftUI
struct ContentView: View {
    @Environment (\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pomodoro.cycles, ascending: true)], animation: .default)
    private var pomodoroList : FetchedResults<Pomodoro>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Bloom.stageInt, ascending: true)],
                  animation: .default)
    private var bloomList: FetchedResults<Bloom>
    
    @State private var userGoal: String = ""
    let myColor = Color("myBackground")
    
    @State var bloomTaks = ["1.Knowledge", "2.Comprehension", "3.Application", "4.Analysis", "5.Synthesis", "6.Evaluation"]
    //@State var chosenBloom : String = ""
    @State private var chosenBloom: Bloom?
    @State private var currentPomodoro: Pomodoro?
    @State private var isActive: Bool = false
    @State private var showInformation = false
    @State private var showInformation2 = false
    @State var easterEgg = ["You have found an easter egg", "Nice taps", "Slow down", "What are you doing", "Thats so many taps", "You're master of taps"]
    @State var messageNO = -1
    @State private var alertActive: Bool = false
    @State private var isGeneratedBloom: Bool = true
    let myFont = Font.system(size: 20, weight: .bold)
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 0.621, green: 0.27, blue: 0.343)
                    .edgesIgnoringSafeArea(.all)
                if (bloomList.count == 0){
                    Button(action: {
                        addBloomList()
                    }){
                        Text("Add bloom list")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                
                Image("logoWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200.0, height: 200.0)
                    .offset(x: -UIScreen.main.bounds.width * 0, y:-UIScreen.main.bounds.height * 0.01)
                    .gesture(TapGesture(count: 2).onEnded{
                        if(messageNO < 5){
                            messageNO += 1
                        }else{
                            messageNO = 0
                        }
                        showInformation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            showInformation = false
                        }
                    })
                    .frame(width: 140.0, height: 160.0)
                    .offset(x: -UIScreen.main.bounds.width * 0, y:-UIScreen.main.bounds.height * 0.2)
                   
                
                VStack{
                    NavigationLink(destination: ClockView(currentPomodoro: $currentPomodoro)){
                        HStack{
                            Text("Clock")
                                .frame(width: 54)
                            Image(systemName: "clock")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    if(isGeneratedBloom == true){
                        Spacer()
                        
                        TextField("Your goal...", text: $userGoal)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .font(.body)
                            .foregroundColor(.primary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        
                        Picker(selection: $chosenBloom, label: Text("Choose the level of Bloom")) {
                            ForEach(bloomList, id: \.self) { bloom in
                                Text(bloom.stage!).tag(bloom as Bloom?)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)

                        
                        Button(action:{
                            if(chosenBloom == nil || userGoal == ""){
                                alertActive = true
                            }else{
                                addPomodoro()
                                isActive = true
                            }
                        }){
                            Text("confirm")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        
                        let _ = print("hey1: \(currentPomodoro?.goal)")
                        NavigationLink(destination: ClockView(currentPomodoro: $currentPomodoro), isActive: $isActive){
                            EmptyView()
                        }
                        Spacer()
                    }
                    
//                    NavigationLink(destination: ClockView(currentPomodoro: $currentPomodoro), isActive: $isActive){
//                        EmptyView()
//                    }
                }
                if showInformation{
                    Text(easterEgg[messageNO])
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .transition(.opacity)
                }
            }
            .onAppear{checkBloom()}
            
        }.alert(isPresented: $alertActive){
            Alert(title: Text("Error"),
                              message: Text("You have to write down a goal and choose the bloom level!"),
                              dismissButton: .default(Text("OK")))}
        .navigationBarBackButtonHidden(true)
        
        }
    
    public func addPomodoro(){
        let newPomodoro = Pomodoro(context: viewContext)
        let myCycles = Int16("0")
        newPomodoro.cycles = myCycles!
        //newPomodoro.time = Date()
        newPomodoro.goal = userGoal
        newPomodoro.toBloom = chosenBloom
        
        let _ = print("hey2: \(currentPomodoro?.goal)")
        currentPomodoro = newPomodoro
        do{
            try viewContext.save()
        }catch{
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        userGoal = ""
    }
    
    
    public func addBloomList(){
        isGeneratedBloom = true
        var temp = 1
        for value in bloomTaks {
            let newBloom = Bloom(context: viewContext)
            newBloom.stage = value
            newBloom.stageInt = Int16(temp)
            temp += 1
        }
        do{
            try viewContext.save()
        }catch{
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    private func checkBloom(){
        isGeneratedBloom = bloomList.isEmpty ? false : true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
