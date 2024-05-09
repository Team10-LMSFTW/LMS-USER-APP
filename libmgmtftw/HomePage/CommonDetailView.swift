import SwiftUI
import FirebaseFirestore

struct BookView:Identifiable {
    let id: String
    let name: String
    let authorName: String
    let genre: String
    let coverURL: String
}

struct PenaltyView:Identifiable {
    let id: String
    let name: String
    let coverURL: String
    let loan_status: String
    let penalty_amount: Int
}

struct CommonDetailView: View {
    var detailType: DetailType
    @AppStorage("userID") private var userID: String = ""
    @State private var books: [BookView] = []
    
    enum DetailType {
        case author(String)
        case genre(String)
        case membership(String)
        case penalty(String)
        
        var title: String {
            switch self {
            case .author:
                return "Top Author"
            case .genre:
                return "Top Genre"
            case .membership:
                return "Membership Details"
            case .penalty:
                return "Penalty Details"
            }
        }
        
        var content: String {
            switch self {
            case .author(let author):
                return "\(author)"
            case .genre(let genre):
                return "\(genre)"
            case .membership(let membership):
                return "\(membership.uppercased())"
            case .penalty(let penalty):
                return "Penalty: Rs.\(penalty)"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading) {
                Spacer()
                Text(detailType.content)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                ForEach(books) { book in
                    BookDetailView2(book: book)
                }
                
                Spacer()
                Spacer()
                Spacer()
                if detailType.title == "Top Author" || detailType.title == "Top Genre" {
                    Text("\(detailType.content) is your \(detailType.title) choice!")
                        .font(.footnote)
                        .foregroundColor(Color.secondary.opacity(0.8)) // Changed from foregroundStyle to foregroundColor
                        .bold()
                        .padding()
                }
                else if detailType.title == "Membership Details" {
                    Text("Currently, you are on the \(detailType.content.lowercased()) plan! Visit the library to upgrade the plan.")
                        .font(.footnote)
                        .foregroundColor(Color.secondary.opacity(0.8)) // Changed from foregroundStyle to foregroundColor
                        .bold()
                        .padding()
                }

            }
        }
        .navigationTitle(detailType.title)
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        switch detailType {
        case .author(let author):
            fetchAuthorDetails(author: author)
        case .genre(let genre):
            fetchGenreDetails(genre: genre)
        case .membership(let membership):
            fetchMembershipDetails(membership: membership)
        case .penalty(let penalty):
            fetchPenaltyDetails(penalty: penalty)
        }
    }
    
    func fetchAuthorDetails(author: String) {
        let db = Firestore.firestore()
        
        db.collection("books")
            .whereField("author_name", isEqualTo: author)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching author details: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No books found for the author: \(author)")
                    return
                }
                
                self.books = documents.compactMap { queryDocumentSnapshot -> BookView? in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let name = data["book_name"] as? String ?? ""
                    let genre = data["category"] as? String ?? ""
                    let authorName = data["author_name"] as? String ?? ""
                    let coverURL = data["cover_url"] as? String ?? ""
                    
                    
                    return BookView(id: id, name: name, authorName: authorName, genre: genre, coverURL: coverURL)
                }
            }
    }

    
    func fetchGenreDetails(genre: String) {
        let db = Firestore.firestore()
        
        db.collection("books")
            .whereField("category", isEqualTo: genre)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching genre details: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No books found for the genre: \(genre)")
                    return
                }
                
                self.books = documents.compactMap { queryDocumentSnapshot -> BookView? in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let name = data["book_name"] as? String ?? ""
                    let genre = data["category"] as? String ?? ""
                    let coverURL = data["cover_url"] as? String ?? ""
                    let authorName = data["author_name"] as? String ?? ""
                    
                    return BookView(id: id, name: name, authorName: authorName, genre: genre, coverURL: coverURL)
                }
            }
    }

    
    func fetchMembershipDetails(membership: String) {
        // Implement fetch function for membership details
        // Example: Fetch membership details from Firestore using membership type
        // Once fetched, update UI or handle data as needed
    }
    
    func fetchPenaltyDetails(penalty: String) {
        let db = Firestore.firestore()
        
        // Query the loans collection for loans with non-null penalty_amount and user_id
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .whereField("penalty_amount", isNotEqualTo: 0)
            .getDocuments { [self] (loanSnapshot, loanError) in
                if let loanError = loanError {
                    print("Error fetching loan details: \(loanError.localizedDescription)")
                    return
                }
                
                // Fetch loan details for each document
                for loanDocument in loanSnapshot!.documents {
                    let loanData = loanDocument.data()
                    let loanStatus = loanData["loan_status"] as? String ?? ""
                    let penaltyAmount = loanData["penalty_amount"] as? Double ?? 0.0
                    
                    // Extract the book ID from the loan data
                    guard let bookID = loanData["book_ref_id"] as? String else {
                        print("No book ID found in loan document: \(loanDocument.documentID)")
                        continue
                    }
                    
                    // Fetch book details using bookID
                    db.collection("books").document(bookID).getDocument { (bookSnapshot, bookError) in
                        if let bookError = bookError {
                            print("Error fetching book details: \(bookError.localizedDescription)")
                            return
                        }
                        
                        guard let bookData = bookSnapshot?.data() else {
                            print("No book details found for book ID: \(bookID)")
                            return
                        }
                        
                        // Extract book details
                        let id = bookSnapshot!.documentID
                        let name = bookData["book_name"] as? String ?? ""
                        let authorName = bookData["author_name"] as? String ?? ""
                        let genre = bookData["category"] as? String ?? ""
                        let coverURL = bookData["cover_url"] as? String ?? ""
                        
                        // Create BookView instance with extracted details
                        let bookView = BookView(id: id, name: name, authorName: authorName, genre: genre, coverURL: coverURL)
                        
                        // Display the combined information as needed
                        print("Book Name: \(bookView.name)")
                        print("Author: \(bookView.authorName)")
                        print("Genre: \(bookView.genre)")
                        print("Loan Status: \(loanStatus)")
                        print("Penalty Amount: \(penaltyAmount)")
                        print("------")
                        
                        //return PenaltyView(id: id, name: name, coverURL: Int(penaltyAmount), loan_status: coverURL)
                        // You can store or display the bookView as required
                    }
                }
            }
    }

}

struct BookDetailView2: View {
    var book: BookView
    
    var body: some View {
       
            VStack(alignment: .leading, spacing: 8) {
                //Text("Book ID: \(book.id)")
                HStack(spacing:15){
                    RemoteImage2(url: book.coverURL)
                    VStack(alignment: .leading, spacing: 5){
                        Text("\(book.name)")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.primary)
                        Text("\(book.authorName)")
                            .font(.subheadline)
                        Text("Genre: \(book.genre)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                    }
                    Spacer()
                }
                
                
            }
            .padding()
            .background(Color.primary.opacity(0.08))
            .cornerRadius(8)
            .padding(.vertical, 4)
        }
    
}
