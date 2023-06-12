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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pomodoro.time, ascending: true)], animation: .default)
    private var pomodoroList : FetchedResults<Pomodoro>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Bloom.id, ascending: true)],
                  animation: .default)
    private var bloomList: FetchedResults<Bloom>
    
    @State private var userGoal: String = ""
    let myColor = Color("myBackground")
    
    @State var bloomTaks = ["Knowledge", "Comprehension", "Application", "Analysis", "Synthesis", "Evaluation"]
    @State var chosenBloom : Int16 = 1
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 0.621, green: 0.27, blue: 0.343)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    TextField("Your goal", text: $userGoal)
                        .border(Color.black)
                        .frame(width: 100)
                        .background(Color.white)
                    
                    Picker(selection: $chosenBloom,
                           label: Text("Choose the level of Bloom")){
                        Text("1. Knowledge").tag(1)
                        Text("2. Comprehension").tag(2)
                        Text("3. Application").tag(3)
                        Text("4. Analysis").tag(4)
                        Text("5. Synthesis").tag(5)
                        Text("6. Evaluation").tag(6)
                        
                        
                    }
                    NavigationLink(destination: ClockView(), label:{
                        Text("confirm")
                            .frame(width: 100)
                            .border(Color.gray)
                    })
                    .onTapGesture {addBloom()}
                }
            }
        }
    }
    
    
    public func addBloom(){
        let newBloom = Bloom(context: viewContext)
        newBloom.stage = chosenBloom
        newBloom.goal = userGoal
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
