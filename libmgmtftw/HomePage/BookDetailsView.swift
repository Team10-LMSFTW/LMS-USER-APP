import SwiftUI
import UIKit
import Firebase
import FirebaseFirestoreSwift

struct BookDetailsView: View {
    @State private var isFavorite = false
    let bookID: String
    @State private var book: Books?

    var body: some View {
        ZStack {
            if let book = book {
                Color(hex: "FAF9F6")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Spacer()
                            Button(action: {
                                isFavorite.toggle()
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(isFavorite ? .red : .black)
                            }
                            .padding()
                            
                            Button(action: {
                                // Content to share
                                if book != nil {
                                    let textToShare = "Check out \(book.book_name) by \(book.author_name)!"
                                    
                                    // Create activity view controller
                                    let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                                    
                                    // Get the current window scene
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                        // Get the relevant window from the window scene
                                        if let viewController = windowScene.windows.first?.rootViewController {
                                            // Present the share sheet
                                            viewController.present(activityViewController, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.black)
                            }


                            
                        }
                        BookHeaderView(book: book)
                        BookDetailInfoView(book: book)
                        Spacer()
                        ActionButtonsView()
                    }
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ProgressView() // Show loading indicator while fetching book details
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("books").document(bookID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            
            guard let document = snapshot, document.exists else {
                print("Document does not exist")
                return
            }

            do {
                self.book = try document.data(as: Books.self)
            } catch {
                print("Error decoding book data: \(error)")
            }
        }
    }


}

struct BookHeaderView: View {
    let book: Books
    
    var body: some View {
        HStack(spacing: 15) {
            Spacer()
            RemoteImage(url: book.cover_url)
                //.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 200)
                .cornerRadius(9)
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text(book.book_name)
                    .font(.title)
                    .fontWeight(.bold)
                
                StarRatingView(rating: 4.5)
                
                Text("Quantity : \(book.quantity)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("Genre: \(book.category)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Available")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.top, 5)
            }
            Spacer()
        }
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct BookDetailInfoView: View {
    let book: Books
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About Book")
                .font(.headline)
            Divider()
            Text("Author: \(book.author_name)")
            Text("Overview:")
                .font(.subheadline)
                .fontWeight(.bold)
            Text("The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it. The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it.")
        }
    }
}

struct ActionButtonsView: View {
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {}) {
                Text("Add to WishList")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Button(action: {}) {
                Text("Borrow now")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
    }
}

struct StarRatingView: View {
    var rating: Double
    
    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                if Double(index) <= rating {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else if Double(index - 1) < rating {
                    Image(systemName: "star.lefthalf.fill")
                        .foregroundColor(.yellow)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct BookDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailsView(bookID: "example_book_id")
    }
}
