//
//  Spend_Much_App.swift
//  Spend Much?
//
//  Created by Parth Antala on 2024-07-08.
//

import SwiftUI
import SwiftData

@main
struct Spend_Much_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Items.self)
    }
}
