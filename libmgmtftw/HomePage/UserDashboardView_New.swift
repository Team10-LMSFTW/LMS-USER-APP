import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct UserDashboardView_New: View {
    
    @AppStorage("userID") private var userID: String = ""
    @State private var booksBorrowed: Int = 0
    @State private var booksBorrowedTotal: Int = 0
    @State private var totalPendingPenalty: Int = 0
    @State private var currentBookName: String = "Anvit Pawar The Great"
    @State private var currentBookAuthor: String = "Anvit Pawar The Great"
    @State private var topGenre: String = "Data Inadequate"
    @State private var topAuthor: String = "Data Inadequate"
    @State private var currentBookCover: String = ""
    @State private var membership_type: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment:.leading,spacing: -5) {
                    
                    //Day, Date, Hi UserName
                    HomePageView1()
                    
                    
                    
                    Section(header:
                                Text("Summary")
                        .foregroundStyle(Color.primary)
                        .padding(.leading, 20))
                    {
                        NavigationLink(destination: EmptyView()){
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.primary.opacity(0.08))
                                .frame(width:350,height: 160)
                                .padding(10)
                                .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                .overlay(
                                    HStack{
                                        VStack(alignment:.leading,spacing: 5){
                                            
                                            Text("\(Image(systemName: "bookmark.circle")) Currently Reading")
                                                .font(.title3)
                                                .foregroundStyle(Color.yellow)
                                                .padding()
                                                .padding(.leading,-25)
                                            
                                            
                                            HStack{
                                                VStack(alignment:.leading){
                                                    Text("\(currentBookName)")
                                                        .lineLimit(1)
                                                        .font(.title2)
                                                        .foregroundStyle(Color.yellow)
                                                        .bold()
                                                    //.padding(.leading,20)
                                                        .padding(.bottom,40)
                                                    
                                                    Text("\(currentBookAuthor)")
                                                        .font(.footnote)
                                                        .foregroundStyle(Color.yellow)
                                                    //.padding(.leading,20)
                                                        .padding(.top,-30)
                                                }
                                            }.padding()
                                            
                                        }
                                        RemoteImage2(url:
                                                        "\(currentBookCover)") // Display cover image
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 90, height: 120)
                                        .cornerRadius(10)
                                        .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                                        
                                        
                                    }
                                )
                        }
                        
                        NavigationLink(destination: HistoryPage()){
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.primary.opacity(0.08))
                                .frame(width:350,height: 160)
                                .padding(10)
                                .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                .overlay(
                                    HStack{
                                        VStack(alignment:.leading,spacing: 5){
                                            
                                            Text("\(Image(systemName: "book")) Books Read")
                                                .font(.title3)
                                                .foregroundStyle(Color.green)
                                                .padding()
                                                .padding(.leading,-25)
                                            
                                            
                                            HStack{
                                                VStack(alignment:.leading){
                                                    Text("\(booksBorrowed) / \(booksBorrowedTotal)")
                                                        .font(.title2)
                                                        .foregroundStyle(Color.green)
                                                        .bold()
                                                    //.padding(.leading,20)
                                                        .padding(.bottom,40)
                                                    
                                                    Text("Books Returned / Borrowed")
                                                        .font(.footnote)
                                                        .foregroundStyle(Color.green)
                                                    //.padding(.leading,20)
                                                        .padding(.top,-30)
                                                }
                                            }
                                            
                                        }
                                        DonutView(fractionFilled: 4/5, fillColor: .green)
                                            .padding()
                                        
                                        
                                    }
                                )
                        }
                    
                        
                        Section(header:
                                    Text("Reccomendations")
                            .foregroundStyle(Color.primary)
                            .padding(.leading, 20))
                        {
                            HStack{
                                NavigationLink(destination: EmptyView()){
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width:165, height: 160)
                                        .padding(10)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            HStack{
                                                VStack(alignment:.leading,spacing: 5){
                                                    
                                                    Text("\(Image(systemName: "medal.fill")) Author")
                                                        .font(.title3)
                                                        .foregroundStyle(Color.blue)
                                                        .padding()
                                                        .padding(.leading,-5)
                                                    
                                                    
                                                    HStack{
                                                        VStack(alignment:.leading){
                                                            Text("\(topAuthor)")
                                                                .font(.title3)
                                                                .foregroundStyle(Color.blue)
                                                                .bold()
                                                            //.padding(.leading,20)
                                                                .padding(.bottom,40)
                                                                .padding(.leading,15)
                                                            
                                                            
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                        )
                                }
                                
                                Spacer()
                                NavigationLink(destination: EmptyView()){
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width:165,height: 160)
                                        .padding(10)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            HStack{
                                                VStack(alignment:.leading,spacing: 5){
                                                    
                                                    Text("\(Image(systemName: "medal.fill")) Genre")
                                                        .font(.title3)
                                                        .foregroundStyle(Color.purple)
                                                        .padding()
                                                        .padding(.leading,-5)
                                                    
                                                    
                                                    HStack{
                                                        VStack(alignment:.leading){
                                                            Text("\(topGenre)")
                                                                .font(.title3)
                                                                .foregroundStyle(Color.purple)
                                                                .bold()
                                                                .padding(.leading,15)
                                                            //.padding(.leading,20)
                                                                .padding(.bottom,40)
                                                            
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                        )
                                }
                            }
                            
                            HStack{
                                NavigationLink(destination: EmptyView()){
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width:165, height: 160)
                                        .padding(10)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            HStack{
                                                VStack(alignment:.leading,spacing: 5){
                                                    
                                                    Text("\(Image(systemName: "person.crop.circle")) Membership")
                                                        .font(.title3)
                                                        .foregroundStyle(Color.orange)
                                                        .padding()
                                                        .padding(.leading,-10)
                                                    
                                                    
                                                    HStack{
                                                        VStack(alignment:.leading){
                                                            Text("\(membership_type)")
                                                                .textCase(.uppercase)
                                                                .font(.title2)
                                                                .foregroundStyle(Color.orange)
                                                                .bold()
                                                            //.padding(.leading,20)
                                                                .padding(.bottom,40)
                                                                .padding(.leading,10)
                                                            
                                                            
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                        )
                                }
                                
                                Spacer()
                                NavigationLink(destination: EmptyView()){
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.primary.opacity(0.08))
                                        .frame(width:165,height: 160)
                                        .padding(10)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                        .overlay(
                                            HStack{
                                                VStack(alignment:.leading,spacing: 5){
                                                    
                                                    Text("\(Image(systemName: "indianrupeesign")) Penalty")
                                                        .font(.title3)
                                                        .foregroundStyle(Color.red)
                                                        .padding()
                                                        .padding(.leading,-40)
                                                    
                                                    
                                                    HStack{
                                                        VStack(alignment:.leading){
                                                            Text("\(totalPendingPenalty)")
                                                                .font(.title2)
                                                                .foregroundStyle(Color.red)
                                                                .bold()
                                                                .padding(.leading,-25)
                                                            //.padding(.leading,20)
                                                                .padding(.bottom,40)
                                                            
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                        )
                                }
                                }
                                HStack{
                                    NavigationLink(destination: ExplorePageView(userID: "", username: "")){
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.primary.opacity(0.08))
                                            .frame(width:165, height: 160)
                                            .padding(10)
                                            .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                            .overlay(
                                                HStack{
                                                    VStack(alignment:.leading,spacing: 5){
                                                        
                                                        Text("\(Image(systemName: "magnifyingglass.circle")) Explore")
                                                            .font(.title3)
                                                            .foregroundStyle(Color.yellow)
                                                            .padding()
                                                            .padding(.leading,-40)
                                                        
                                                        
                                                        HStack{
                                                            VStack(alignment:.leading){
                                                                Text(Image(systemName: "ellipsis"))
                                                                    .font(.largeTitle)
                                                                    .foregroundStyle(Color.yellow)
                                                                    .bold()
                                                                //.padding(.leading,20)
                                                                    .padding(.bottom,40)
                                                                    .padding(.leading,-25)
                                                                
                                                                
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                            )
                                    }
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: RequestsPage()){
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.primary.opacity(0.08))
                                            .frame(width:165,height: 160)
                                            .padding(10)
                                            .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                                            .overlay(
                                                HStack{
                                                    VStack(alignment:.leading,spacing: 5){
                                                        
                                                        Text("\(Image(systemName: "books.vertical.circle")) Request")
                                                            .font(.title3)
                                                            .foregroundStyle(Color.green)
                                                            .padding()
                                                            .padding(.leading,-40)
                                                        
                                                        
                                                        HStack{
                                                            VStack(alignment:.leading){
                                                                Text(">")
                                                                    .font(.title2)
                                                                    .foregroundStyle(Color.green)
                                                                    .bold()
                                                                    .padding(.leading,-25)
                                                                //.padding(.leading,20)
                                                                    .padding(.bottom,40)
                                                                
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                            )
                                    }
                                    
                                
                            }
                        }
                        
                        .listStyle(.plain) // Use plain list style
                    }.onAppear(){
                        fetchBooksBorrowed()
                        fetchCurrentBookDetails()
                        fetchTotalPendingPenalty()
                        fetchMembership()
                        fetchTop()
                    }
                    .padding() // Add padding to the VStack
                }.navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                
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
            .whereField("loan_status", isEqualTo: "returned")
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
        
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching loans: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No loan documents found")
                    return
                }
                booksBorrowedTotal = documents.count
                print("Number of books returned: \(documents.count)")
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
            .whereField("loan_status", isEqualTo: "accepted")
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
                    print(bookRefID)
                    
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
        
        
        
        
        
//        struct UserDashboardView_New_Previews: PreviewProvider {
//            static var previews: some View {
//                UserDashboardView_New()
//            }
//        }
    
