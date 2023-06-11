//
//  ContentView.swift
//  LaboProjekt
//
//  Created by student on 06/06/2022.
//  Copyright © 2022 student. All rights reserved.
//

import SwiftUI
struct ContentView: View {
    @Environment (\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pomodoro.time, ascending: true)], animation: .default)
    private var Lists : FetchedResults<Pomodoro>
    @State private var title : String = ""
    @State var alert = false
    
    @State private var userGoal: String = ""
    let myColor = Color("myBackground")
    @State var bloomTaks = ["Knowledge", "Comprehension", "Application", "Analysis", "Synthesis", "Evaluation"]
    @State var chosenBloom : String = ""
    
    
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
                        Text("1. Knowledge").tag("Knowledge")
                        Text("2. Comprehension").tag("Comprehension")
                        Text("3. Application").tag("Application")
                        Text("4. Analysis").tag("Analysis")
                        Text("5. Synthesis").tag("Synthesis")
                        Text("6. Evaluation").tag("Evaluation")
                        
                        
                    }
                    NavigationLink(destination: ClockView(), label:{
                        Text("confirm")
                            .frame(width: 100)
                            .border(Color.gray)
                    })
                    
                    
                }
            }
            
        
        }
        
        VStack{
            NavigationView{
                VStack{
                    TextField("Your goal", text: $userGoal)
                        .border(Color.gray)
                        .frame(width: 100)
                    
                }
            }
//            NavigationView{
//                VStack{
//                    NavigationLink(destination: Converter()){
//                        Text("Konwerter")
//                    }
//                    List {
//                        ForEach(Lists, id: \.self) {
//                            list in
//                            NavigationLink(destination: ListContents(list: list)){
//                                Text(list.title!)
//                            }
//                        }.onDelete(perform: deleteList)
//                    }
//                    if(alert == true)
//                    {
//                        Text("Tytuł jest za krótki").foregroundColor(.red)
//                    }
//                    TextField("Tytuł nowej listy", text: $title).onTapGesture {
//                        self.title = ""
//                    }
//                    Button("Dodaj Listę") {
//                        self.addList()
//                    }
//                }
//            }.navigationViewStyle(StackNavigationViewStyle())
        }
        
    }
    public func addList() {
        alert = false
        if(title != "")
        {
            let newList = ShoppingList(context: context)
            newList.title = title
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Error: \(error), \(error.userInfo)")
            }
            title = ""
        }
        else
        {
            alert = true
        }
        
    }
    private func deleteList(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                Lists[$0]
            }.forEach(context.delete)
            do {
                try context.save()
            } catch {
                let myError = error as NSError
                fatalError("Błąd przy usuwaniu rekordu \(myError), \(myError.userInfo)")
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
