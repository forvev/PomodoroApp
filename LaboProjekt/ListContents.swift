//
//  ListContents.swift
//  LaboProjekt
//
//  Created by student on 06/06/2022.
//  Copyright © 2022 student. All rights reserved.
//

import SwiftUI

struct ListContents: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItem.itemName, ascending: true)], animation: .default)
    private var items: FetchedResults<ShoppingItem>
    var list : ShoppingList
    @State var name: String = ""
    @State var quantity: String = ""
    @State var alert = false
    var body: some View {
        VStack {
            Text("Lista: \(list.title!)")
            List{
                ForEach(list.itemArray, id: \.self) {
                    thing in
                    Text("\(thing.itemName!), ilość: \(thing.quantity)")
                }.onDelete(perform: deleteItem)
            }
            if(alert == true)
            {
                Text("Wpisano niepoprawną ilość produktu").foregroundColor(.red)
            }
            HStack{
                TextField("Podaj nazwę produktu",text: $name)
                TextField("Podaj ilość",text: $quantity)
            }
            Button("Dodaj produkt") {
                self.addItem()
            }
        }
        
        
    }
    private func addItem() {
        alert = false
        let newItem = ShoppingItem(context: context)
        newItem.itemName = name
        if(Int32(quantity) != nil)
        {
            let intQuantity = Int32(quantity)!
            newItem.quantity = intQuantity
            newItem.shoppingList = list
            
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Error: \(error), \(error.userInfo)")
            }
            name = ""
            quantity = ""
        }
        else
        {
            alert = true
        }
        
    }
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                items[$0]
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

/*struct ListContents_Previews: PreviewProvider {
    static var previews: some View {
        ListContents(list: )
    }
}*/
