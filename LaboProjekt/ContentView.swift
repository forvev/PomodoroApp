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
    @State private var isActive: Bool = false
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 0.621, green: 0.27, blue: 0.343)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    if (bloomList.count == 0 ){
                        Button(action: addBloomList){
                            Text("Add bloom list")
                        }
                    }
                    NavigationLink(destination: ClockView()){
                        Text("Go to the clock directly")
                            .border(Color.black)
                            .frame(width: 100)
                    }
                    
                    TextField("Your goal", text: $userGoal)
                        .border(Color.black)
                        .frame(width: 100)
                        .background(Color.white)
                    
                    
                    Picker(selection: $chosenBloom,  label: Text("Choose the level of Bloom")){
                        Text("").tag("")
                        ForEach(bloomList, id: \.self) { (bloom: Bloom) in
                            Text(bloom.stage!).tag(bloom as Bloom?)
                        }
                    }
                    Button(action:{
                        addPomodoro()
                        isActive = true
                    }){
                        Text("confirm")
                            .frame(width: 100)
                            .border(Color.gray)
                    }
                    
//                    NavigationLink(destination: ClockView().onAppear{
//                        addPomodoro()
//                    },label: {
//                        Text("confirm")
//                            .frame(width: 100)
//                            .border(Color.gray)
//                    })
                    NavigationLink(destination: ClockView(), isActive: $isActive){
                        EmptyView()
                    }
                }
            }
        }
    }
    
    public func addPomodoro(){
        let newPomodoro = Pomodoro(context: viewContext)
        let myCycles = Int16("0")
        newPomodoro.cycles = myCycles!
        //newPomodoro.time = Date()
        newPomodoro.goal = userGoal
        
        newPomodoro.toBloom = chosenBloom
        
        do{
            try viewContext.save()
        }catch{
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        userGoal = ""
    }
    
    
    public func addBloomList(){
        print("addBloomList")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
