import SwiftUI
import Firebase
import FirebaseFirestoreSwift


struct Books: Identifiable, Codable {
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

struct ExplorePageView: View {
    let userID: String
    let username: String
    
    @State private var searchText = ""
    @State private var books: [Books] = []
    @State private var filteredBooks: [Books] = []
    @State private var selectedBookID: String?
    @State private var selectedCategory: String?
    
    init(userID: String, username: String) {
        self.userID = userID
        self.username = username
    }

    var body: some View {
        GeometryReader { geo in
            NavigationView{
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [Color(hex: "211134"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                        .ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack{
                            TextField("Search", text: $searchText)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding()
                            Spacer()
                            Button(action: search) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        ScrollView {
                            VStack(alignment: .leading) {
                                Text("Categories")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                CategoryScrollView(book: books, selectedCategory: $selectedCategory)
                                
                                Text("Collections")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                TrendingCollectionsView(books: filteredBooks, selectedCategory: selectedCategory)
                            }
                        }
                    }
                }
                .onAppear {
                    fetchData()
                    print("Username: \(username)")
                    print("UserID: \(userID)")
                }
                .navigationBarBackButtonHidden(true)
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
                
                // Map Firestore documents to Book objects
                self.books = documents.compactMap { document in
                    do {
                        let book = try document.data(as: Books.self)
                        return book
                    } catch {
                        print("Error decoding document: \(error)")
                        return nil
                    }
                }
                // Update filteredBooks when books are fetched
                self.filteredBooks = self.books
            }
        }
    }
    
    private func search() {
        if searchText.isEmpty {
            // If search text is empty, display all books
            filteredBooks = books
        } else {
            // Filter books based on search text
            let filtered = books.filter { $0.book_name.lowercased().contains(searchText.lowercased()) }
            if filtered.isEmpty {
                // If no books match the search criteria, display a message
                filteredBooks = [Books(id: nil, author_name: "N/A", book_name: "Book not available", category: "N/A", cover_url: "N/A", isbn: "N/A", library_id: "N/A", loan_id: "N/A", quantity: 0, thumbnail_url: "N/A")]
            } else {
                // Otherwise, display the filtered books
                filteredBooks = filtered
            }
        }
    }
}

struct ExplorePageView_Previews: PreviewProvider {
    static var previews: some View {
        ExplorePageView(userID: "your_user_id_here", username: "your_username_here")
    }
}


struct TrendingCollectionsView: View {
    var books: [Books]
    var selectedCategory: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(books) { book in
                    if selectedCategory == nil || book.category == selectedCategory {
                        NavigationLink(destination: BookDetailsView(bookID: book.id ?? "")) {
                            VStack {
                                RemoteImage(url: book.thumbnail_url)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 200)
                                    .cornerRadius(10)

                                HStack {
                                    Text(book.book_name)
                                        .foregroundColor(.white)
                                    Text(String(book.quantity))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding([.horizontal, .bottom])
                            }
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(20)
                        }
                    }
                }
            }
        }
    }
}



struct RemoteImage: View {
    let url: String
    @State private var image: UIImage?

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .frame(width: 200, height: 170)
        } else {
            Image("placeholder") // Placeholder image
                .resizable()
                .onAppear {
                    loadImage(from: url)
                }
        }
    }

    private func loadImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

struct CategoryScrollView: View {
    var book: [Books]
    @Binding var selectedCategory: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedCategory == category ? Color.blue.opacity(0.8) : Color.gray.opacity(0.5))
                            .frame(width: 130, height: 30)
                            .onTapGesture {
                                selectedCategory = category == "All Categories" ? nil : category
                            }
                        Text(category)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
    }

    var categories: [String] {
        var categories = Set(book.map { $0.category }).sorted()
        categories.insert("All Categories", at: 0) // Add "All Categories" option at the beginning
        return categories
    }
}
