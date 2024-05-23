//
//  Quote.swift
//  PlayingWithSwiftData
//
//  Created by Mackley Magalhães da Silva on 08/05/24.
//

import Foundation
import SwiftData

@Model
class Quote {
    var creationDate: Date = Date.now
    var text: String
    var page: String?
    
    init(text: String, page: String? = nil) {
        self.text = text
        self.page = page
    }
    
    var book: Book?
}
