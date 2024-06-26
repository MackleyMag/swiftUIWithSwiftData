//
//  EditBookView.swift
//  PlayingWithSwiftData
//
//  Created by Mackley Magalhães da Silva on 07/05/24.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    let book: Book
    @State private var status: Status
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var synopsis = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var recomendedBy = ""
    @State private var showGenre = false
    
    init(book: Book) {
        self.book = book
        _status = State(initialValue: Status(rawValue: book.status)!)
    }
    
    var body: some View {
        HStack {
            Text("Status ")
            Picker("Status", selection:  $status) {
                ForEach(Status.allCases) { status in
                    Text(status.descr).tag(status)
                }
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    switch status {
                    case .onShelf:
                        DatePicker("", selection: $dateAdded, displayedComponents: .date)
                    case .inProgress, .completed:
                        DatePicker("", selection: $dateAdded, in: ...dateStarted,
                                   displayedComponents: .date)
                    }
                } label: {
                    Text("Date Added")
                }
                if status == .inProgress || status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
                    } label: {
                        Text("Date Started")
                    }
                }
                if status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)
                    } label: {
                        Text("Date Completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if newValue == .onShelf {
                    dateStarted = Date.distantPast
                    dateCompleted = Date.distantPast
                } else if newValue == .inProgress && oldValue == .completed {
                    dateCompleted = Date.distantPast
                } else if newValue == .inProgress && oldValue == .onShelf {
                    dateStarted = Date.now
                } else if newValue == .completed && oldValue == .onShelf {
                    dateCompleted = Date.now
                    dateStarted = dateAdded
                } else {
                    dateCompleted = Date.now
                }
            }
            Divider()
            
            LabeledContent {
                RatingsView(maxRating: 5, currentRating: $rating, width: 30)
            } label: {
                Text("Rating")
            }
            LabeledContent {
                TextField("", text: $author)
            } label: {
                Text("Author").foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $recomendedBy)
            } label: {
                Text("Recomended By").foregroundStyle(.secondary)
            }
            Divider()
            Text("Synopsis").foregroundStyle(.secondary)
            TextEditor(text: $synopsis)
                .padding(5)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(uiColor: .tertiarySystemFill), lineWidth:2)
                    
                }
            if let genres = book.genres {
                ViewThatFits {
                    ScrollView(.horizontal, showsIndicators: false) {
                        GenresStackView(genres: genres)
                    }
                }
            }
            HStack {
                Button("Genres", systemImage: "bookmark.fill") {
                    showGenre.toggle()
                }
                .sheet(isPresented: $showGenre, content: {
                    GenresView(book: book)
                })
                NavigationLink {
                    QuotesListView(book: book)
                } label: {
                    let count = book.quotes?.count ?? 0
                    Label("\(count) Quotes", systemImage: "quote.opening")
                }
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {
                Button("Update") {
                    book.status = status.rawValue
                    book.rating = rating
                    book.title = title
                    book.author = author
                    book.synopsis = synopsis
                    book.dateAdded = dateAdded
                    book.dateCompleted = dateCompleted
                    book.dateStarted = dateStarted
                    book.recomendedBy = recomendedBy
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            rating = book.rating
            title = book.title
            author = book.author
            synopsis = book.synopsis
            dateAdded = book.dateAdded
            dateCompleted = book.dateCompleted
            dateStarted = book.dateStarted
            recomendedBy = book.recomendedBy
        }
    }
    
    var changed: Bool {
        status != Status(rawValue: book.status)!
        || rating != book.rating
        || title != book.title
        || author != book.author
        || synopsis != book.synopsis
        || dateAdded != book.dateAdded
        || dateCompleted != book.dateCompleted
        || dateStarted != book.dateStarted
        || recomendedBy != book.recomendedBy
    }
}

#Preview {
    let preview = PreviewContainer(Book.self)
    return NavigationStack {
        EditBookView(book: Book.sampleBooks[4])
            .modelContainer(preview.container)
    }
}
