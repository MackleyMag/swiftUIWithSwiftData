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
        .modelContainer(container)
    }
    
    init() {
        let schema = Schema([Book.self])
        let config = ModelConfiguration("PlayingWithSwiftData", schema: schema)
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
    }
}
