//
//  PlayingWithSwiftDataApp.swift
//  PlayingWithSwiftData
//
//  Created by Mackley Magalhães da Silva on 07/05/24.
//

import SwiftUI
import SwiftData

@main
struct PlayingWithSwiftDataApp: App {
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            BookListView()
        }
        .modelContainer(for: Book.self)
    }
    
    init() {
        let schema = Schema([Book.self])
        let config = ModelConfiguration("MyBooks", schema: schema)
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
    }
}
