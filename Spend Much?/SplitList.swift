//
//  SplitList.swift
//  Spend Much?
//
//  Created by Parth Antala on 2024-07-09.
//

import SwiftUI
import SwiftData

struct SplitList: View {
    var type: String
    @Environment(\.modelContext) var modelContext
    @Query var items: [Items]
    
    @Binding var totalPersonal: Double
    @Binding var totalBusiness: Double
    
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
                
                List {
                    Section(header: Text("").foregroundColor(.white)) {
                        ForEach(items.filter { $0.type == type }) { item in
                            
                            
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
                .navigationTitle(type)
                .scrollContentBackground(.hidden)
            }
        }
    }
    
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

//#Preview {
//    SplitList(expenses: Expance(), type: "Personal")
//}
