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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.title, ascending: true)], animation: .default)
    private var Lists : FetchedResults<ShoppingList>
    @State private var title : String = ""
    @State var alert = false
    
    
    
    var body: some View {
        VStack{
            NavigationView{
                VStack{
                    NavigationLink(destination: Converter()){
                        Text("Konwerter")
                    }
                    List {
                        ForEach(Lists, id: \.self) {
                            list in
                            NavigationLink(destination: ListContents(list: list)){
                                Text(list.title!)
                            }
                        }.onDelete(perform: deleteList)
                    }
                    if(alert == true)
                    {
                        Text("Tytuł jest za krótki").foregroundColor(.red)
                    }
                    TextField("Tytuł nowej listy", text: $title).onTapGesture {
                        self.title = ""
                    }
                    Button("Dodaj Listę") {
                        self.addList()
                    }
                }
            }.navigationViewStyle(StackNavigationViewStyle())
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
