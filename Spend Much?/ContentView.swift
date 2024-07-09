//
//  ContentView.swift
//  Spend Much?
//
//  Created by Parth Antala on 2024-07-08.
//

import SwiftUI
import Observation


struct Item: Identifiable {
    let id = UUID()
    var name: String
    var type: String
    var amount: Double
}

@Observable
class Expance {
    var items = [Item]()
}

struct ContentView: View {
    @State private var expance = Expance()
    @State private var showingAddExpense = false
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expance.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("Expenses")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                // show an AddView here
                AddView(expenses: expance)
            }
           
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expance.items.remove(atOffsets: offsets)
    }
  
    
    
}


#Preview {
    ContentView()
}
