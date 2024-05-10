import SwiftUI
import FirebaseFirestore
import AVFoundation

struct BookView: Identifiable {
    let id: String
    let name: String
    let authorName: String
    let genre: String
    let coverURL: String
}

struct PenaltyView: Identifiable {
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
    @State private var penalties: [PenaltyView] = []
    
    @State private var isReading: Bool = false
    let synthesizer = AVSpeechSynthesizer()
    
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
                return "Amount Due ₹ \(penalty)"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text(detailType.content)
                        .font(.title)
                        .bold()
                        .padding()
                    Spacer()
                    Button(action: {
                        readAloud()
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title)
                            .padding()
                    }
                }
                
                if detailType.title == "Penalty Details" {
                    ForEach(penalties) { penalty in
                        PenaltyDetailView(book: penalty)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            // Add action to handle payment with Apple Pay
                            // This could include navigating to a payment screen or performing a payment action
                        }) {
                            Text("Pay using Apple Pay")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .frame(width: 150, height: 15)
                                .padding()
                                .background(Color.primary.opacity(0.08))
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                } else {
                    ForEach(books) { book in
                        BookDetailView2(book: book)
                    }
                }
                
                if detailType.title == "Top Author" || detailType.title == "Top Genre" {
                    Text("\(detailType.content) is your \(detailType.title) choice!")
                        .font(.footnote)
                        .foregroundColor(Color.secondary.opacity(0.8))
                        .bold()
                        .padding()
                } else if detailType.title == "Membership Details" {
                    // Membership details view
                    VStack(alignment:.leading, spacing: 20) {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.primary.opacity(0.08))
                                                .frame(width: 360, height: 160)
                                                .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                                .overlay(
                                                    HStack{
                                                        VStack(alignment:.leading) {
                                                            Text("Premium Member")
                                                                .font(.title3)
                                                                .foregroundColor(.primary)
                                                                .padding()
                                                            Text("Unlock exclusive features with 10 books per month")
                                                                .font(.body)
                                                                .foregroundColor(.secondary)
                                                                .multilineTextAlignment(.leading)
                                                                .padding(.horizontal)
                                                            Spacer()
                                                        }
                                                        Spacer()
                                                        Text("Rs. 300/Month")
                                                            .font(.body)
                                                            .underline()
                                                            .foregroundColor(.blue)
                                                            .multilineTextAlignment(.leading)
                                                            .padding(.horizontal)
                                                    
                                                    }
                                                    )
                        RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.primary.opacity(0.08))
                                                        .frame(width: 360, height: 160)
                                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                                        .overlay(
                                                            HStack{
                                                                VStack(alignment:.leading) {
                                                                    Text("Basic Member")
                                                                        .font(.title3)
                                                                        .foregroundColor(.primary)
                                                                        .padding()
                                                                    Text("Access to a wide range of books, 6 books per month")
                                                                        .font(.body)
                                                                        .foregroundColor(.secondary)
                                                                        .multilineTextAlignment(.leading)
                                                                        .padding(.horizontal)
                                                                    Spacer()
                                                                }
                                                                Spacer()
                                                                Text("Rs. 100/Month")
                                                                    .font(.body)
                                                                    .underline()
                                                                    .foregroundColor(.blue)
                                                                    .multilineTextAlignment(.leading)
                                                                    .padding(.horizontal)
                                                            }
                                                        )
                                                    
                                                    // Premium Membership
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.primary.opacity(0.08))
                                                        .frame(width: 360, height: 160)
                                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                                        .overlay(
                                                            HStack{
                                                                VStack(alignment:.leading) {
                                                                    Text("Free Member")
                                                                        .font(.title3)
                                                                        .foregroundColor(.primary)
                                                                        .padding()
                                                                    Text("Fundamental plan, 2 books per month")
                                                                        .font(.body)
                                                                        .foregroundColor(.secondary)
                                                                        .multilineTextAlignment(.leading)
                                                                        .padding(.horizontal)
                                                                    Spacer()
                                                                }
                                                                Spacer()
                                                                Text("Free")
                                                                    .font(.body)
                                                                    .foregroundColor(.primary)
                                                                    .multilineTextAlignment(.leading)
                                                                    .padding(.horizontal)
                                                            }
                                                        )
                                                }
                                                .padding(.vertical)
                                            
                                            .padding()
                                                    }
                                                
                }
            
        }
        .navigationTitle(detailType.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchData()
        }
    }
    
    func readAloud() {
        isReading.toggle()
        if isReading {
            switch detailType {
            case .penalty(let penalty):
                for penalty in penalties {
                    let content = "\(penalty.name), loan status \(penalty.loan_status), penalty amount \(penalty.penalty_amount)"
                    speak(content: content)
                }
            default:
                for book in books {
                    let content = "Book Name: \(book.name), Book Genre: \(book.genre), Author Name: \(book.authorName)"
                    speak(content: content)
                }
            }
        } else {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    
    func speak(content: String) {
        let utterance = AVSpeechUtterance(string: content)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
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
        // Fetch membership details
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
                            
                            print("Book Name: \(name)")
                            print("Loan Status: \(loanStatus)")
                            print("Penalty Amount: \(penaltyAmount)")
                            print("------")
                            
                            // Create PenaltyView instance with extracted details
                            let penaltyView = PenaltyView(id: id, name: name, coverURL: coverURL, loan_status: loanStatus,  penalty_amount: Int(penaltyAmount))
                            
                            // Append the PenaltyView instance to the penalties array
                            DispatchQueue.main.async {
                                self.penalties.append(penaltyView)
                            }
                        }
                    }
                }
        }
}

struct BookDetailView2: View {
    var book: BookView
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 15) {
                 RemoteImage2(url: book.coverURL)
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(book.name)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.primary)
                    Text("\(book.authorName)")
                        .foregroundStyle(Color.secondary)
                        .font(.subheadline)
                    Text("Genre: \(book.genre)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.primary.opacity(0.08))
        .cornerRadius(20)
        .padding(.vertical, 4)
    }
}

struct PenaltyDetailView: View {
    var book: PenaltyView
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 15) {
                 RemoteImage2(url: book.coverURL)
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(book.name)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.primary)
                    Text("\(book.loan_status.uppercased())")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                    Text("Penalty Due: Rs. \(book.penalty_amount)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.primary.opacity(0.08))
        .cornerRadius(20)
        .padding(.vertical, 4)
    }
}
