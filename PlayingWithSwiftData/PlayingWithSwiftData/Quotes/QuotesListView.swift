//
//  QuotesListView.swift
//  PlayingWithSwiftData
//
//  Created by Mackley Magalhães da Silva on 22/05/24.
//

import SwiftUI

struct QuotesListView: View {
    @Environment(\.modelContext) private var modelContext
    let book: Book
    @State private var text = ""
    @State private var page = ""
    @State private var selectedQuote: Quote?
    var isEditing: Bool {
        selectedQuote != nil
    }
    
    var body: some View {
        GroupBox {
            HStack {
                LabeledContent("Page") {
                    TextField("page #", text: $page)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                    Spacer()
                }
                if isEditing {
                    Button("Cancel") {
                        page = ""
                        text = ""
                        selectedQuote = nil
                    }
                    .buttonStyle(.bordered)
                }
                Button(isEditing ? "Update" : "Create") {
                    if isEditing {
                        selectedQuote?.text = text
                        selectedQuote?.page = page.isEmpty ? nil : page
                        page = ""
                        text = ""
                        selectedQuote = nil
                    } else {
                        let quote = page.isEmpty ? Quote(text: text) : Quote(text: text, page: page)
                        book.quotes?.append(quote)
                        text = ""
                        page = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(text.isEmpty)
            }
            TextEditor(text: $text)
                .border(Color.secondary)
                .frame(height: 100)
        }
        .padding(.horizontal)
        List {
            let sortedQuotes = book.quotes?.sorted(using: KeyPathComparator(\Quote.creationDate)) ?? []
            ForEach(sortedQuotes) { quoute in
                VStack(alignment: .leading) {
                    Text(quoute.creationDate, format: .dateTime.month().day().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(quoute.text)
                    HStack {
                        Spacer()
                        if let page = quoute.page, !page.isEmpty {
                            Text("Page: \(page)")
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedQuote = quoute
                    text = quoute.text
                    page = quoute.page ?? ""
                }
            }
            .onDelete { indexSet in
                withAnimation {
                    indexSet.forEach { index in
                        if let quote = book.quotes?[index] {
                            modelContext.delete(quote)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Quotes")
    }
}

#Preview {
    let preview = PreviewContainer(Book.self)
    let books = Book.sampleBooks
    preview.addExamples(books)
    
    return NavigationStack{
        QuotesListView(book: books[4])
            .navigationBarTitleDisplayMode(.inline)
            .modelContainer(preview.container)
    }
}
