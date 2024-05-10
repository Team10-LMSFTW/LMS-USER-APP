import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Book: Identifiable, Codable {
    @DocumentID var id: String?
    var author_name: String
    var book_name: String
    var category: String
    var cover_url: String
    var isbn: String
    var library_id: String
    var loan_id: String
    var quantity: Int
    var thumbnail_url: String
}

struct BookListView: View {
    @State private var books: [Book] = []
    @State private var documentIDs: [String] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(0..<books.count, id: \.self) { index in
                    NavigationLink(destination: BookDetailView(book: books[index])) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(books[index].book_name)
                                    .font(.headline)
                                Text(books[index].author_name)
                                    .font(.subheadline)
                                Text(books[index].isbn)
                                    .font(.subheadline)
                            }
                            // Add other book details as needed
                        }
                    }
                }
            }
            .navigationTitle("Books List")
            .onAppear {
                fetchData()
            }
        }
    }
    
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("books").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                guard let documents = snapshot?.documents else {
                    print("No documents found.")
                    return
                }

                // Extract the document IDs and count
                self.documentIDs = documents.map { $0.documentID }

                // Map Firestore documents to Book objects
                self.books = documents.compactMap { document in
                    do {
                        let book = try document.data(as: Book.self)
                        return book
                    } catch {
                        print("Error decoding document: \(error)")
                        return nil
                    }
                }
            }
        }
    }
}




struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))]) {
                VStack(alignment: .leading, spacing: 10) {
                    BookDetailRow(label: "Name", value: book.book_name)
                    BookDetailRow(label: "Author", value: book.author_name)
                    BookDetailRow(label: "ISBN", value: book.isbn)
                    BookDetailRow(label: "Category", value: book.category)
                    BookDetailRow(label: "Library ID", value: book.library_id)
                    BookDetailRow(label: "Loan ID", value: book.loan_id)
                    BookDetailRow(label: "Quantity", value: "\(book.quantity)")
                }

                // Display thumbnail image independently
                BookImageLoader(imageURL: book.thumbnail_url)
                    //.resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()

            }
            .padding()
        }
        .navigationTitle("Book Detail")
    }
}

struct BookDetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.bold)
            Spacer()
            
                Text(value)
        }
    }
}




struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
    }
}
