//
//  AddView.swift
//  Spend Much?
//
//  Created by Parth Antala on 2024-07-08.
//

import SwiftUI

enum Currency: String, CaseIterable {
    case CAD = "CAD"
    case USD = "USD"
    case INR = "INR"
}

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount: Double = 0.0
    @State private var currency: Currency = .USD
    let types = ["Business", "Personal"]
    var expenses: Expance
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                MeshGradient(width: 3, height: 3, points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ], colors: [
                    .purple, .white, .white,
                    .purple, .purple, .white,
                    .purple, .purple, .purple
                ])
                .ignoresSafeArea()
                
                Form {
                    TextField("Name", text: $name)
                        .listRowBackground(Color.white.opacity(0.4))
                    
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.white.opacity(0.4))
                    
                    HStack {
                        TextField("Amount", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                            
                        Picker("Currency", selection: $currency) {
                            ForEach(Currency.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        
                        
                    }
                    .listRowBackground(Color.white.opacity(0.4))
                    
                    }
                .toolbar {
                    Button("Save") {
                        withAnimation {
                            let item = Item(name: name, type: type, amount: amount, currency: currency.rawValue)
                            expenses.items.append(item)
                            expenses.calculateTotals()
                            dismiss()
                        }
                    }
                    .buttonStyle()
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    AddView(expenses: Expance())
}
