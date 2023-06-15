//
//  BloomStatus.swift
//  LaboProjekt
//
//  Created by Artur Zelik on 14/06/2023.
//  Copyright © 2023 student. All rights reserved.
//

import SwiftUI

struct BloomStatus: View {
    @Environment (\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pomodoro.cycles, ascending: true)], animation: .default)
    private var pomodoroList : FetchedResults<Pomodoro>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Bloom.stage, ascending: true)],
                  animation: .default)
    private var bloomList: FetchedResults<Bloom>
    
    var body: some View {
        ZStack{
            Color(red: 0.621, green: 0.27, blue: 0.343)
                .edgesIgnoringSafeArea(.all)
            VStack{
                List{
                    ForEach(bloomList){ bloom in
                        Section(header: Text("\(bloom.stage!)")){
                            ForEach(bloom.pomodoroArray){ pomodoro in
                                HStack{
                                    Text("Your goal: \(pomodoro.goal ?? "")")
                                    Spacer()
                                    Text("Cycles: \(pomodoro.cycles)")
                                }
                            }
                        }
                    }.onDelete(perform: deleteBloom)
                }
            }
        }
    }
    
    private func deleteBloom(offsets: IndexSet) {
        withAnimation {
            offsets.map { bloomList[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//struct BloomStatus_Previews: PreviewProvider {
//    static var previews: some View {
//        BloomStatus()
//    }
//}
