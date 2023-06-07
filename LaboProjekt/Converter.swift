//
//  Converter.swift
//  LaboProjekt
//
//  Created by student on 13/06/2022.
//  Copyright © 2022 student. All rights reserved.
//

import SwiftUI

struct Converter: View {
    @State private var wybor1: String = ""
    @State var wybor2: String = ""
    @State var ile: String = ""
    @State var wynik: String = ""
    @State var mn1: Float = 0.0
    @State var mn2: Float = 0.0
    @State var mnoznik: Float = 0.0

    var body: some View {
        VStack{
            Image("Waga").resizable().aspectRatio(contentMode: .fit).gesture(TapGesture().onEnded({_ in
                self.ile = ""
            }))
            HStack{
                Picker(selection: $wybor1, label: Text("")) {
                    Text("lb").tag("lb")
                    Text("g").tag("g")
                    Text("ct").tag("ct")
                    Text("kg").tag("kg")
                    Text("oz").tag("oz")
                }.pickerStyle(WheelPickerStyle())
                    .padding()
                    .onAppear{
                        self.wybor1 = "lb"
                    }
                Picker(selection: $wybor2, label: Text("")) {
                    Text("lb").tag("lb")
                    Text("g").tag("g")
                    Text("ct").tag("ct")
                    Text("kg").tag("kg")
                    Text("oz").tag("oz")
                }.pickerStyle(WheelPickerStyle())
                    .padding()
                    .onAppear{
                        self.wybor2 = "lb"
                    }
                
            }
            HStack{
                TextField("Podaj ilość", text: $ile).padding().frame(width: 200)
                Button("Przelicz") {
                    self.oblicz()
                }
            }
            
            Text(wynik)
        }
    }
    private func oblicz(){
        wynik = ""
        switch wybor1 {
        case "lb":
            mn1 = 453.59237
        case "g":
            mn1 = 1.0
        case "ct":
            mn1 = 0.2
        case "kg":
            mn1 = 1000.0
        case "oz":
            mn1 = 28.34952
        default:
            mn1 = 1
        }
        
        switch wybor2 {
        case "lb":
            mn2 = 453.59237
        case "g":
            mn2 = 1.0
        case "ct":
            mn2 = 0.2
        case "kg":
            mn2 = 1000.0
        case "oz":
            mn2 = 28.34952
        default:
            mn2 = 1
        }
        if (Float(ile) != nil)
        {
            mnoznik = mn1/mn2
            wynik = "Wynik: \(Float(ile)! * mnoznik) \(wybor2)"
            mn1 = 0.0
            mn2 = 0.0
        }
        else
        {
            wynik = "Wpisano niepoprawny numer"
            mn1 = 0.0
            mn2 = 0.0
        }
        
        
        
    }
    
}



