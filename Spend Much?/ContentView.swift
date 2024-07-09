//
//  ContentView.swift
//  Spend Much?
//
//  Created by Parth Antala on 2024-07-08.
//

import SwiftUI
import Observation



struct Item: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String
    var amount: Double
    var currency: String

}

@Observable
class Expance {
    var totalPersonal: Double = 0.0
    var totalBusiness: Double = 0.0
    
    var items = [Item](){
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        print("Expance initialized.")
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([Item].self, from: savedItems) {
                items = decodedItems
                calculateTotals()
                return
            }
            
        }

        items = []
    }
    
    func calculateTotals() {
            totalPersonal = items.filter { $0.type == "Personal" }.map { $0.amount }.reduce(0, +)
            totalBusiness = items.filter { $0.type == "Business" }.map { $0.amount }.reduce(0, +)
        print("Total Personal: \(totalPersonal), Total Business: \(totalBusiness)") // Debug print to verify totals
    }
    
}

struct ContentView: View {
    @State private var expance = Expance()
    @State private var showingAddExpense = false
    @State private var showingPersonalList = false
    @State private var showingBusinessList = false
    @State private var choosedType = "Personal"
    @State private var totalPersonal: Double = 0.0
    @State private var totalBusiness: Double = 0.0
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                MeshGradient(width: 3, height: 3, points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ], colors: [
                    .purple, .purple, .white,
                    .purple, .white, .purple,
                    .white, .white, .purple
                ])
                .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .opacity(0.4)
                            .shadow(radius: 10)
                            .frame(height: 110)
                            .padding()
                        
                        HStack {
                            VStack {
                                Text("Personal")
                                Text("\(expance.totalPersonal, format: .currency(code: "USD"))")
                            }
                            .onTapGesture {
                                showingPersonalList = true
                            }
                            .sheet(isPresented: $showingPersonalList) {
                                SplitList(expenses: expance, type: "Personal")
                                    .presentationDetents([.fraction(0.4), .medium, .large])
                            }
                            Spacer()
                            VStack {
                                Text("Business")
                                Text("\(expance.totalBusiness, format: .currency(code: "USD"))")
                            }
                            .onTapGesture {
                                showingBusinessList = true
                            }
                            .sheet(isPresented: $showingBusinessList) {
                                SplitList(expenses: expance, type: "Business")
                                    .presentationDetents([.fraction(0.4), .medium, .large])
                            }
                        }
                        .padding(55)


                    }
                    .frame(height: 150)
                   
                List {
                    Section(header: Text("All entries").foregroundColor(.white)) {
                        ForEach(expance.items) { item in
                            
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                
                                Spacer()
                                Text(item.amount, format: .currency(code: item.currency))
                            }
                            .listRowBackground(Color.white.opacity(item.amount < 10 ? 0.4 : (item.amount < 100 && item.amount > 10) ? 0.6 : 0.8))
                            
                        }
                        .onDelete(perform: removeItems)
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Expenses")
                .toolbar {
                    Button("Add Expense", systemImage: "plus") {
                        showingAddExpense = true
                    }
                    .buttonStyle()
                }
                .sheet(isPresented: $showingAddExpense) {
                    // show an AddView here
                    AddView(expenses: expance)
                        .presentationDetents([.fraction(0.4), .medium, .large])
                }
            }
        }
           
        }
    }
    
    func removeItems(at offsets: IndexSet) {
       expance.items.remove(atOffsets: offsets)
      
        expance.calculateTotals()
    }
  
   
    
    
}

struct ButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .buttonStyle(.borderedProminent)
        .tint(.purple.opacity(0.4))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

extension View {
    func buttonStyle() -> some View {
        modifier(ButtonViewModifier())
    }
}

#Preview {
    ContentView()
}
