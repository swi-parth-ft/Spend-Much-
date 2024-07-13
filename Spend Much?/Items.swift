//
//  Items.swift
//  Spend Much?
//
//  Created by Parth Antala on 2024-07-13.
//

import Foundation
import SwiftData

@Model
class Items {
    var name: String
    var type: String
    var amount: Double
    var currency: String
    
    init(name: String, type: String, amount: Double, currency: String) {
        self.name = name
        self.type = type
        self.amount = amount
        self.currency = currency
    }
    
    
}
