//
//  BookList.swift
//  PlayingWithSwiftData
//
//  Created by Mackley Magalhães da Silva on 08/05/24.
//

import SwiftUI
import SwiftData

struct BookList: View {
    
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]
    
    
    init(sortOrder: SortOrder, filter: String) {
        let sortDescriptors: [SortDescriptor<Book>] = switch sortOrder {
        case .status:
            [SortDescriptor(\Book.status), SortDescriptor(\Book.title)]
        case .title:
            [SortDescriptor(\Book.title)]
        case .author:
            [SortDescriptor(\Book.author)]
        }
        let predicate = #Predicate<Book> { book in
            book.title.localizedStandardContains(filter)
            || book.author.localizedStandardContains(filter)
            || filter.isEmpty
        }
        _books = Query(filter: predicate, sort: sortDescriptors)
    }
    
    var body: some View {
        Group {
            if books.isEmpty {
                ContentUnavailableView("Enter your first book", systemImage: "book.fill")
            } else {
                List {
                    ForEach(books) { book in
                        NavigationLink {
                            EditBookView(book: book)
                        } label: {
                            HStack(spacing: 10) {
                                book.icon
                                VStack(alignment: .leading) {
                                    Text(book.title).font(.title2)
                                    Text(book.author).foregroundStyle(.secondary)
                                    if let rating = book.rating {
                                        HStack {
                                            ForEach(1..<rating, id: \.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.yellow)
                                            }
                                        }
                                    }
                                    if let genres = book.genres {
                                        ViewThatFits {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                GenresStackView(genres: genres)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let book = books[index]
                            context.delete(book)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(Book.self)
    preview.addExamples(Book.sampleBooks)
    return NavigationView {
        BookList(sortOrder: .status, filter: "")
    }
    .modelContainer(preview.container)
}
