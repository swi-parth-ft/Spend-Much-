//
//  SplitList.swift
//  Spend Much?
//
//  Created by Parth Antala on 2024-07-09.
//

import SwiftUI

struct SplitList: View {
    var type: String
    @State private var contentView = ContentView()
    
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
//                    Section(header: Text("").foregroundColor(.white)) {
//                        ForEach(expenses.items.filter { $0.type == type }) { item in
//                            
//                            
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text(item.name)
//                                        .font(.headline)
//                                    Text(item.type)
//                                }
//                                
//                                Spacer()
//                                Text(item.amount, format: .currency(code: item.currency))
//                            }
//                            .listRowBackground(Color.white.opacity(item.amount < 10 ? 0.4 : (item.amount < 100 && item.amount > 10) ? 0.6 : 0.8))
//                            
//                        }
//                        .onDelete {
//                            contentView.removeItems(at: $0)
//                            expenses.calculateTotals()
//                        }
//                    }
                }
                .navigationTitle(type)
                .scrollContentBackground(.hidden)
            }
        }
    }
    
//    func removeItems(at offsets: IndexSet, type: String) {
//        expenses.items.removeAll { item in
//            offsets.contains(where: { expenses.items.firstIndex(of: item) == $0 }) && item.type == type
//        }
//        expenses.calculateTotals()
//    }
}

//#Preview {
//    SplitList(expenses: Expance(), type: "Personal")
//}
