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
    var body: some Scene {
        WindowGroup {
            BookListView()
        }
        .modelContainer(for: Book.self)
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
