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

struct Book: Codable {
    var name: String
    var isnb: Double
}
struct ContentView: View {
    
    @State private var user = User()
    @State private var isPresented: Bool = false
    @State private var numbers: [Int] = []
    @State private var nextNumber: Int = 1
    @AppStorage("tapCount") private var tapCount = 0
    
    
    @State private var GOT: Book = Book(name: "GameofThrons", isnb: 82746724574)
    @State private var got: Book?
    
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
                    let decoder = JSONDecoder()
                    
                    if let data = UserDefaults.standard.data(forKey: "Books") {
                        if let decodedBook = try? decoder.decode(Book.self, from: data) {
                            got = decodedBook
                        }
                    }
                }.sheet(isPresented: $isPresented) {
                    secondView(book: got ?? Book(name: "non", isnb: 82746724574))
                }
                
                List {
                    ForEach(numbers, id: \.self ) {
                        Text("Row \($0)")
                        
                    }
                    .onDelete(perform: removeRow)
                }
                Button("Add Book") {
                    let encoder = JSONEncoder()
                    
                    if let data = try? encoder.encode(GOT) {
                        UserDefaults.standard.set(data, forKey: "Books")
                    }
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
    var book: Book
    var body: some View {
        VStack {
            Text(book.name)
            Button("dismiss") {
                dismiss()
            }
        }
    }
}

#Preview {
    ContentView()
}
