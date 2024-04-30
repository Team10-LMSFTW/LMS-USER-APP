import SwiftUI
import UIKit
import Firebase
import FirebaseFirestoreSwift

struct BookDetailsView: View {
   //
    let bookID: String
    @State private var book: Books?

    var body: some View {
        //NavigationStack{
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                    .ignoresSafeArea()
                
                if let book = book {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            BookHeaderView(book: book)
                            BookDetailInfoView(book: book)
                            Spacer()
                            ActionButtonsView(bookID: bookID)
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
       // }.navigationBarBackButtonHidden(true)
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
                    .frame(width: 120, height: 200)
                    .cornerRadius(9)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(book.book_name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    StarRatingView(rating: 4.5)
                    
                    Text("Quantity : \(book.quantity)")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    Text("Genre: \(book.category)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    if book.quantity != 0 {
                        Text("Available")
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .padding(.top, 5)
                    } else {
                        Text("Unavailable")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 20)
            .background(Color(hex: "AFAFB3", opacity: 0.2))
            .cornerRadius(10)
            .shadow(radius: 3)
        }
    
}

struct BookDetailInfoView: View {
    let book: Books
    @State private var isFavorite = false
    var body: some View {
        @State  var isFavorite = false
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Author: \(book.author_name)")
                .font(.title2)
            
                Spacer()
                Button(action: {
                    isFavorite.toggle()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                }
                .padding()
                //Spacer()
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
                        .foregroundColor(.white)
                }
            }
            Divider()
                

//            Text("Overview:")
//                .font(.title2)
//                .bold()
//                
//            Text("The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it. The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it.")
        }
        .foregroundColor(.white) // Text color set to white
    }
}

struct ActionButtonsView: View {
    let bookID: String
    @State private var isShowingBorrowSheet = false // State to control the presentation of the modal sheet

    var body: some View {
        VStack(spacing: 15) { // Wrap in a VStack for better layout
            Button(action: {
                // Set the state to true to present the BorrowPageUI as a modal sheet
                isShowingBorrowSheet.toggle()
            }) {
                Text("Borrow now")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "AFAFB3", opacity : 0.2)) // Grey background color with opacity
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding() // Add padding to the VStack
        .sheet(isPresented: $isShowingBorrowSheet) { // Present BorrowPageUI as a modal sheet
            BorrowPageUI(bookID: bookID)
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
