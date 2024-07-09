//
//  ContentView.swift
//  Spend Much?
//
//  Created by Parth Antala on 2024-07-08.
//

import SwiftUI
import Observation

@Observable
class User {
    var firstName = "Parth"
    var lastName = "Antala"
}
struct ContentView: View {
    
    @State private var user = User()
    @State private var isPresented: Bool = false
    @State private var numbers: [Int] = []
    @State private var nextNumber: Int = 1
    @AppStorage("tapCount") private var tapCount = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, \(user.firstName) \(user.lastName)")
                TextField("First Name", text: $user.firstName)
                TextField("Last Name", text: $user.lastName)
                
                Button("Present sheet") {
                    isPresented = true
                }.sheet(isPresented: $isPresented) {
                    secondView()
                }
                
                List {
                    ForEach(numbers, id: \.self ) {
                        Text("Row \($0)")
                        
                    }
                    .onDelete(perform: removeRow)
                }
                
                Button("Add number") {
                    numbers.append(tapCount)
                    tapCount += 1
                    tapCount += 1
                }
            }
            .toolbar {
                EditButton()
            }
           
        }
    }
    
    func removeRow(at offset: IndexSet) {
        numbers.remove(atOffsets: offset)
    }
    
    
}


struct secondView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Second View")
            Button("dismiss") {
                dismiss()
            }
        }
    }
}

#Preview {
    ContentView()
}
