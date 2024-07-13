//
//  ContentView.swift
//  Spend Much?
//
//  Created by Parth Antala on 2024-07-08.
//
import SwiftData
import SwiftUI
import Observation

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    
    @State private var showingAddExpense = false
    @State private var showingPersonalList = false
    @State private var showingBusinessList = false
    @State private var choosedType = "Personal"
    @State private var totalPersonal: Double = 0.0
    @State private var totalBusiness: Double = 0.0
    
    
    @State private var sortOrder = [
        SortDescriptor(\Items.name),
        SortDescriptor(\Items.amount),
    ]
    
    @Query var items: [Items]
    
    
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
                                Text("\(totalPersonal, format: .currency(code: "USD"))")
                            }
                            .onTapGesture {
                                showingPersonalList = true
                            }
                            .sheet(isPresented: $showingPersonalList) {
                                SplitList(type: "Personal", totalPersonal: $totalPersonal, totalBusiness: $totalBusiness)
                                    
                            }
                            Spacer()
                            VStack {
                                Text("Business")
                                Text("\(totalBusiness, format: .currency(code: "USD"))")
                            }
                            .onTapGesture {
                                showingBusinessList = true
                            }
                            .sheet(isPresented: $showingBusinessList) {
                                SplitList(type: "Business", totalPersonal: $totalPersonal, totalBusiness: $totalBusiness)
                                   
                            }
                        }
                        .padding(55)


                    }
                    .frame(height: 150)
                   
                    ListView(totalPersonal: $totalPersonal, totalBusiness: $totalBusiness, sortOrder: sortOrder)
                .scrollContentBackground(.hidden)
                    
                .navigationTitle("Expenses")
                .toolbar {
                 
                        Button("Add Expense", systemImage: "plus") {
                            showingAddExpense = true
                        }
                        .buttonStyle()
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort By", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([
                                    SortDescriptor(\Items.name),
                                    SortDescriptor(\Items.amount),
                                ])
                            
                            Text("Sort by Amount")
                                .tag([
                                    SortDescriptor(\Items.amount),
                                    SortDescriptor(\Items.name),
                                ])
                        }
                    }
                    .buttonStyle()

                    
                    
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddView(totalPersonal: $totalPersonal, totalBusiness: $totalBusiness)
                        .presentationDetents([.fraction(0.4), .medium, .large])
                }
                .onAppear {
                    calculateTotal()
                }
                
            }
        }
           
        }
    }
    
    
 
    func calculateTotal() {
        totalPersonal = items.filter { $0.type == "Personal" }.map { $0.amount }.reduce(0, +)
        totalBusiness = items.filter { $0.type == "Business" }.map { $0.amount }.reduce(0, +)
    }
}

struct ListView: View {
    @Query var items: [Items]
    @Environment(\.modelContext) var modelContext
    
    @Binding var totalPersonal: Double
    @Binding var totalBusiness: Double
    var sortOrder: [SortDescriptor<Items>]
    
    
    var body: some View {
        List {
            Section(header: Text("All entries").foregroundColor(.white)) {
                ForEach(items.sorted(using: sortOrder)) { item in
                    
                    
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
                .onDelete(perform: deleteItems)
            }
        }
    }
    
//    init(sortDescriptor: [SortDescriptor<Items>]) {
//        _items = Query(sort: sortDescriptor)
//    }
    
    
    func deleteItems(_ indexSet: IndexSet) {
        for i in indexSet {
            let item = items[i]
            if item.type == "Personal" {
                totalPersonal -= item.amount
            } else {
                totalBusiness -= item.amount
            }
            modelContext.delete(item)
        }
        
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
