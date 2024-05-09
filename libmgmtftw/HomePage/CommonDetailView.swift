import SwiftUI
import FirebaseFirestore

struct BookView {
    let id: String
    let name: String
    let authorName: String
    let genre: String
   // let description: String
}

struct CommonDetailView: View {
    var detailType: DetailType
    @AppStorage("userID") private var userID: String = ""
    
    enum DetailType {
        case author(String)
        case genre(String)
        case membership(String)
        case penalty(String)
        
        var title: String {
            switch self {
            case .author:
                return "Author Details"
            case .genre:
                return "Genre Details"
            case .membership:
                return "Membership Details"
            case .penalty:
                return "Penalty Details"
            }
        }
        
        var content: String {
            switch self {
            case .author(let author):
                return "Author: \(author)"
            case .genre(let genre):
                return "Genre: \(genre)"
            case .membership(let membership):
                return "Membership: \(membership.uppercased())"
            case .penalty(let penalty):
                return "Penalty: Rs.\(penalty)"
            }
        }
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment:.center) {
                Spacer()
                Text(detailType.content)
                    .font(.title2)
                    .padding()
                Spacer()
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
                
                // Convert documents to an array of Book objects
                let books = documents.compactMap { queryDocumentSnapshot -> BookView? in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let name = data["book_name"] as? String ?? ""
                    let genre = data["category"] as? String ?? ""
                    let authorName = data["author_name"] as? String ?? ""
                   // let description = data["description"] as? String ?? ""
                    // You can add more fields as needed
                    
                    return BookView(id: id, name: name, authorName: authorName, genre: genre)
                }
                
               
                // Example: You can display the books in a List
                // For simplicity, I'm just printing the book names here
                for book in books {
                    print("Book Name: \(book.name)")
                    print("Genre: \(book.genre)")
                    print("Author: \(book.authorName)")
                    print("------")
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
                
                // Print fetched books to the terminal
                for document in documents {
                    let data = document.data()
                    let id = document.documentID
                    let name = data["book_name"] as? String ?? ""
                    let genre = data["category"] as? String ?? ""
                    let authorName = data["author_name"] as? String ?? ""
                    
                    print("Book Name: \(name)")
                    print("Genre: \(genre)")
                    print("Author: \(authorName)")
                    print("------")
                }
            }
    }

    
    func fetchMembershipDetails(membership: String) {
        // Implement fetch function for membership details
        // Example: Fetch membership details from Firestore using membership type
        // Once fetched, update UI or handle data as needed
    }
    
    func fetchPenaltyDetails(penalty: String) {
        // Implement fetch function for penalty details
        // Example: Fetch penalty details from Firestore using penalty value
        // Once fetched, update UI or handle data as needed
    }
}
