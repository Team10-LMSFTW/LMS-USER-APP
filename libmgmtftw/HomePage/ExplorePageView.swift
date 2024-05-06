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
            NavigationStack{
                ZStack {
                    
                    Color.black.ignoresSafeArea()
                    
                    VStack(alignment: .leading) {
                        ScrollView {
                        HStack{
                            TextField("Search", text: $searchText)
                                .padding()
                                .frame(width:320, height: 40)
                                .background(Color.primary.opacity(0.8))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .padding()
                            //Spacer()
                            Button(action: search) {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .foregroundColor(.primary.opacity(0.8))
                                
                                    .font(.largeTitle)
                                
                            }
                            .padding(.leading, -15)
                        }
                        
                       
                            VStack(alignment: .leading) {
//                                Text("Categories")
//                                    .bold()
//                                    .font(.largeTitle)
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal)
//                                    //.padding(.top)
//                                
                                CategoryScrollView(book: books, selectedCategory: $selectedCategory)
                                
                                Text("Collections")
                                    .bold()
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    //.padding(.top)
                                
                                TrendingCollectionsView(books: filteredBooks, selectedCategory: selectedCategory)
                            }
                        }
                    }
                }//.navigationBarHidden(true)
               // .navigationBarBackButtonHidden(true)
                .onChange(of: searchText) { _ in
                            search()
                        }
                .onAppear {
                    fetchData()
                }
                
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
            let filtered = books.filter { book in
                let lowercasedSearchText = searchText.lowercased()
                return book.author_name.lowercased().contains(lowercasedSearchText) ||
                       book.book_name.lowercased().contains(lowercasedSearchText) ||
                       book.category.lowercased().contains(lowercasedSearchText)
                // Add more properties if needed
            }
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
                                RemoteImage(url: book.cover_url)
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 140, height: 180)
                                    .cornerRadius(10)
                                    .padding(.top)

                                VStack(spacing: 4) {
                                    Text(book.book_name)
                                        .foregroundColor(.white)
                                        .lineLimit(1) // Limit to one line
                                        .frame(width: 140) // Fixed width
                                        .truncationMode(.tail) // Truncate with "..."
                                    Text(String(book.quantity))
                                        .foregroundColor(.white)
                                }
                                .padding([.horizontal, .bottom])
                            }
                            .background(Color.primary.opacity(0.08))
                            .cornerRadius(20)
                                        }
                    }
                }
            }
        }.padding(.horizontal)
    }
}



struct RemoteImage: View {
    let url: String
    @State private var image: UIImage?

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .cornerRadius(25)
                .frame(width: 200, height: 170)
        } else {
            ProgressView()
            
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
    @State private var isExpanded: Bool = false
    @State private var showAllCategories: Bool = false
    @State private var displayedCategoriesCount: Int = 2 // Initially display 2 categories

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories.prefix(displayedCategoriesCount), id: \.self) { category in // Display only 'displayedCategoriesCount' categories initially
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.primary.opacity(0.08))
                                .frame(width: 92, height: 32)
                                .onTapGesture {
                                    selectedCategory = category == "All Categories" ? nil : category
                                }
                            Text(category)
                                .foregroundColor(.white)
                                .font(.footnote)
                        }
                    }
                    // Show ">" button to toggle list view
                    Button(action: {
                        isExpanded.toggle()
                        if isExpanded {
                            displayedCategoriesCount = categories.count // Show all categories
                        } else {
                            displayedCategoriesCount = 3 // Show only 2 categories
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.left" : "chevron.right") // Change arrow direction based on state
                            .frame(width: 45, height: 28)
                            .background(Color.primary.opacity(0.08))
                            .cornerRadius(80.0)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 8)
                }
                .padding()
            }
            
            if isExpanded {
                List(categories.dropFirst(3), id: \.self) { category in // Show other categories in a list if expanded
                    Text(category)
                }
                .padding()
            }
        }
    }

    var categories: [String] {
        var categories = Set(book.map { $0.category }).sorted()
        categories.insert("All Categories", at: 0) // Add "All Categories" option at the beginning
        return categories
    }
}
