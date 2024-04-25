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
    @State private var searchText = ""
    @State private var books: [Books] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(hex: "211134"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                    .ignoresSafeArea()
                
                Image("grad1")
                    .frame(width: 215, height: 215)
                    .background(Color(red: 0.05, green: 0.27, blue: 0.36))
                    .blur(radius: 100)
                
                Image("grad2")
                    .frame(width: 215, height: 215)
                    .background(Color(red: 0.26, green: 0.05, blue: 0.36))
                    .blur(radius: 100)
                
                VStack(alignment: .leading) {
                    HStack{
                        TextField(" ", text: $searchText)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .padding()
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Categories")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            CategoryScrollView()
                            
                            Text("Trending collections")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            TrendingCollectionsView(books: books)
                        }
                    }
                }
            }
            .overlay(
                TabBar()
                    .position(x:200, y:760)
            )
        }
        .onAppear {
            fetchData()
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
            }
        }
    }
}

struct TrendingCollectionsView: View {
    var books: [Books]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(books.prefix(3)) { book in
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

struct RemoteImage: View {
    let url: String
    @State private var image: UIImage?

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
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
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(0..<10) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 100, height: 30)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExplorePageView()
    }
}
