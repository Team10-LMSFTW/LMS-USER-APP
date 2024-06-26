import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct UserDashboardView_New: View {
    
    @AppStorage("userID") private var userID: String = ""
    @State private var booksBorrowed: Int = 0
    @State private var booksBorrowedTotal: Int = 0
    @State private var totalPendingPenalty: Int = 0
    @State private var currentBookName: String = "Nil"
    @State private var currentBookAuthor: String = "Nil"
    @State private var topGenre: String = "-"
    @State private var topAuthor: String = "-"
    @State private var currentBookCover: String = ""
    @State private var membership_type: String = ""
    @State private var book_id: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    
                    HomePageView1()
                        .padding()
                        //.padding(.trailing, 215)
                    
                    Text("Summary")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.primary)
                        .padding(.trailing, 220)
                    
                    
                    VStack(spacing: 20) {
                        
                        NavigationLink(destination: ViewBookDetail(bookID: book_id )) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.primary.opacity(0.08))
                                .frame(width: 360, height: 160)
                                .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                .overlay(
                                    HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("\(Image(systemName: "bookmark.circle")) Currently Reading")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundStyle(Color.primary)
                                            
                                            Text("\(currentBookName)")
                                                .font(.title3)
                                                .foregroundColor(.blue)
                                                .bold()
                                            
                                            Text("\(currentBookAuthor)")
                                                .font(.footnote)
                                                .foregroundStyle(Color.blue)
                                        }
                                        .padding(.trailing, 60)
                                        
                                        RemoteImage2(url: "\(currentBookCover)")
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 90, height: 120)
                                            .cornerRadius(10)
                                    }
                                    
                                )
                        }
                        
                        NavigationLink(destination: HistoryPage()) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.primary.opacity(0.08))
                                .frame(width: 360, height: 160)
                                .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                .overlay(
                                    HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("\(Image(systemName: "book")) Books Read")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundStyle(Color.primary)
                                            
                                            Text("\(booksBorrowed) / \(booksBorrowedTotal)")
                                                .font(.title)
                                                .foregroundStyle(Color.purple)
                                                .bold()
                                            
                                            Text("Books Returned / Available")
                                                .font(.footnote)
                                                .foregroundStyle(Color.purple)
                                        }
                                        .padding(.trailing, 60)
                                        
                                        DonutView(fractionFilled: Double(booksBorrowed) / Double(booksBorrowedTotal), fillColor: .purple)
                                    }
                                )
                        }
                        
                        
                        Text("Trends")
                            .font(.title)
                            .bold()
                            .foregroundStyle(Color.primary)
                            .padding(.trailing, 240)
                        
                        VStack(spacing: 20){
                            
                            HStack(spacing: 20) {
                                NavigationLink(destination: CommonDetailView(detailType: .author("\(topAuthor)"))) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width: 170, height: 120)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            VStack(spacing: 10) {
                                                Text("\(Image(systemName: "medal.fill")) Author")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundStyle(Color.primary)
                                                
                                                Text("\(topAuthor)")
                                                    .font(.title3)
                                                    .foregroundStyle(Color.orange)
                                                    .bold()
                                            }
                                        )
                                }
                                
                                NavigationLink(destination: CommonDetailView(detailType: .genre("\(topGenre)"))) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width: 170, height: 120)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            VStack(spacing: 10) {
                                                Text("\(Image(systemName: "medal.fill")) Genre")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundStyle(Color.primary)
                                                
                                                Text("\(topGenre)")
                                                    .font(.title3)
                                                    .foregroundStyle(Color.indigo)
                                                    .bold()
                                            }
                                        )
                                }
                            }
                            
                            HStack(spacing: 20) {
                                NavigationLink(destination: CommonDetailView(detailType: .membership("\(membership_type)"))) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width: 170, height: 120)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            VStack(spacing: 10) {
                                                Text("\(Image(systemName: "person.crop.circle")) Membership")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundStyle(Color.primary)
                                                
                                                Text("\(membership_type)")
                                                    .textCase(.uppercase)
                                                    .font(.title)
                                                    .foregroundStyle(Color.mint)
                                                    .bold()
                                            }
                                        )
                                }
                                
                                NavigationLink(destination: CommonDetailView(detailType: .penalty("\(totalPendingPenalty)"))) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width: 170, height: 120)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            VStack(spacing: 10) {
                                                Text("\(Image(systemName: "indianrupeesign")) Penalty")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundStyle(Color.primary)
                                                
                                                Text("\(totalPendingPenalty)")
                                                    .font(.title)
                                                    .foregroundStyle(Color.green)
                                                    .bold()
                                            }
                                        )
                                }
                            }
                            
                            HStack(spacing: 20) {
                                NavigationLink(destination: ExplorePageView(userID: "", username: "")) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width: 170, height: 120)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            VStack(spacing: 10) {
                                                Text("\(Image(systemName: "magnifyingglass.circle")) Explore")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundStyle(Color.primary)
                                                
                                                Text(Image(systemName: "book.pages.fill"))
                                                    .font(.largeTitle)
                                                    .foregroundStyle(Color.green)
                                                    .bold()
                                            }
                                        )
                                }
                                
                                NavigationLink(destination: RequestsPage()) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width: 170, height: 120)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            VStack(spacing: 10) {
                                                Text("\(Image(systemName: "books.vertical.circle")) Request")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundStyle(Color.primary)
                                                
                                                Text(Image(systemName: "rectangle.and.text.magnifyingglass"))
                                                    .font(.largeTitle)
                                                    .foregroundStyle(Color.mint)
                                                    .bold()
                                            }
                                        )
                                }
                            }
                        }
                        
                        .onAppear() {
                            fetchBooksBorrowed()
                            fetchCurrentBookDetails()
                            fetchTotalPendingPenalty()
                            fetchMembership()
                            fetchTop()
                        }
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                    }
                }
            }
        }
    }
    func fetchMembership() {
        let db = Firestore.firestore()
        db.collection("users").document(userID)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                }
                
                guard let document = documentSnapshot else {
                    print("No document found.")
                    return
                }
                
                if document.exists {
                    if let membershipType = document["membership_type"] as? String {
                        // Update the membership_type variable
                        membership_type = membershipType
                        print("Membership type: \(membershipType)")
                    } else {
                        print("Membership type not found in document.")
                    }
                } else {
                    print("No membership document found for user.")
                }
            }
    }




    
    func fetchBooksBorrowed() {
        let db = Firestore.firestore()
        
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .whereField("loan_status", in: ["inactive", "due"])
            
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching loans: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No loan documents found")
                    return
                }
                booksBorrowed = documents.count
                print("Number of books borrowed: \(documents.count)")
            }
        
        db.collection("books")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching books: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("No book documents found")
                        return
                    }
                    
                    booksBorrowedTotal = documents.count
                    print("Total number of books: \(documents.count)")
            }
    }
    func fetchTotalPendingPenalty() {
        let db = Firestore.firestore()
        var pendingPenalty = 0 // Initialize total pending penalty
        
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID) // Assuming userID is already defined
        //.whereField("loan_status", isEqualTo: "accepted")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching loans: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No loan documents found")
                    return
                }
                
                let currentDate = Date()
                for document in documents {
                    
                    
                    
                    let penaltyAmount : Int = document["penalty_amount"] as! Int
                    // Assuming penalty rate is $30 per day
                    pendingPenalty += penaltyAmount
                }
                totalPendingPenalty = pendingPenalty
                print("Total pending penalty amount: \(totalPendingPenalty)")
            }
    }
    
    
    private func fetchCurrentBookDetails() {
       // print("i was called")
        let db = Firestore.firestore()
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .whereField("loan_status", isEqualTo: "active")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                if let loanDocument = documents.first {
                    guard let bookRefID = loanDocument["book_ref_id"] as? String else {
                        print("Book reference ID not found.")
                        return
                    }
                   // print(bookRefID)
                    
                    db.collection("books").document(bookRefID).getDocument { bookSnapshot, bookError in
                        if let bookError = bookError {
                            print("Error fetching book document: \(bookError)")
                            return
                        }
                        
                        guard let bookData = bookSnapshot?.data(),
                              let bookName = bookData["book_name"] as? String,
                              let authorName = bookData["author_name"] as? String,
                              let coverURL = bookData["cover_url"] as? String else {
                            print("Book data not found.")
                            return
                        }
                        
                        // Update state variables with fetched data
                        currentBookName = bookName
                        currentBookAuthor = authorName
                        currentBookCover = coverURL
                        book_id = bookRefID
                    }
                }
            }
    }
    
    private func fetchTop() {
        var authorCounts: [String: Int] = [:]
        var genreCounts: [String: Int] = [:]
        
        let db = Firestore.firestore()
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                // Use DispatchGroup to wait for asynchronous operations
                let group = DispatchGroup()
                
                // Count occurrences of author names and genres
                for document in documents {
                    guard let bookRefID = document["book_ref_id"] as? String else {
                        print("Book reference ID not found.")
                        continue
                    }
                    
                    group.enter() // Enter the group before each asynchronous operation
                    
                    db.collection("books").document(bookRefID).getDocument { bookSnapshot, bookError in
                        defer {
                            group.leave() // Leave the group when the asynchronous operation completes
                        }
                        
                        if let bookError = bookError {
                            print("Error fetching book document: \(bookError)")
                            return
                        }
                        
                        guard let bookData = bookSnapshot?.data(),
                              let authorName = bookData["author_name"] as? String,
                              let genre = bookData["category"] as? String else {
                            print("Book data not found.")
                            return
                        }
                        
                        
                        // Update counts inside the group's closure
                        authorCounts[authorName, default: 0] += 1
                        genreCounts[genre, default: 0] += 1
                        
                    }
                }
                
                // Wait for all asynchronous operations to finish
                group.notify(queue: .main) {
                    // Find author with max count
                    if let maxAuthor = authorCounts.max(by: { $0.value < $1.value }) {
                        topAuthor = maxAuthor.key ?? ""
                    }
                    
                    // Find genre with max count
                    if let maxGenre = genreCounts.max(by: { $0.value < $1.value }) {
                        topGenre = maxGenre.key ?? ""
                    }
                }
            }
    }
}
        
        
        
        

struct UserDashboardView_New_Previews: PreviewProvider {
    static var previews: some View {
        UserDashboardView_New()
    }
}
