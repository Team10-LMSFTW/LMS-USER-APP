import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RequestsPage: View {
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var userEmail: String = ""
    @State private var requestHistory : [BookRequest] = [] // Changed loanHistory to requestHistory
    @State private var isPresentingRequestBookPage: Bool = false
    @State private var bookRequest: BookRequest
    init(bookRequest: BookRequest = BookRequest(id: UUID(), bookName: "", author: "", description: nil, edition: nil, status: 0)) {
            _bookRequest = State(initialValue: bookRequest)
        }

    var body: some View {
        if isLoggedIn {
            NavigationStack {
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Request New Books")
                            .foregroundColor(.white)
                            .font(.title)
//                            .padding(.top,20)
//                        Text("Logged in as: \(userEmail)")
//                            .foregroundColor(.white)
//                            .padding()
//                        Text()
                        
                        List {
                            ForEach(requestHistory) { request in
                                RequestHistoryRow(request: request)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding()
                    }
                    
//                    ZStack
                    VStack {
                                            Spacer()
                                            
                                            HStack {
                                                Spacer()
                                                
                                                Button(action: {
                                                    // Navigate to RequestBookPage
                                                    self.isPresentingRequestBookPage = true
                                                }) {
                                                    Image(systemName: "plus.app")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                        .padding()
                                                }
                                                .background(Color.orange)
                                                .cornerRadius(12)
                                                .padding(.trailing, 20) // Adjust the trailing padding
                                                .padding(.bottom, 20) // Adjust the bottom padding
                                                .sheet(isPresented: $isPresentingRequestBookPage) {
                                                    RequestsaddView(bookRequest: bookRequest)
                                                }
                                            }
                                        }
                                    }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    fetchUserEmail()
                    fetchRequestHistory()
                }
            }.navigationBarBackButtonHidden(true)
        } else {
            NavigationLink(destination: LoginView(), isActive: $isLoggedIn) {
            }
        }
    }
    
    func fetchUserEmail() {
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email ?? "Unknown"
            if let atIndex = userEmail.firstIndex(of: "@") {
                userEmail = String(userEmail[..<atIndex])
            }
        }
    }
    func fetchRequestHistory() {
          guard let userID = UserDefaults.standard.string(forKey: "userID") else { return }
    
            let db = Firestore.firestore()
   
        db.collection("requests")
              .whereField("id", isEqualTo: userID)
    ////            .whereField("library_id", isEqualTo: "1")
           .getDocuments { snapshot, error in
                if let error = error {
                        print("Error fetching request history: \(error.localizedDescription)")
                     return
                  }
  
                  guard let documents = snapshot?.documents else {
                       print("No request history found")
                        return
                  }
                   self.requestHistory = documents.compactMap { document in
                       guard let bookName = document["bookName"] as? String,
                              let author = document["author"] as? String,
                              let status = document["status"] as? Int else {
                           // Ensure essential data is present
                         return nil
                      }
   
                       // Optional properties
                    let description = document["description"] as? String
                        let edition = document["edition"] as? String
                        print(bookName , status)
                       return BookRequest(id: UUID(), bookName: bookName, author: author, description: description, edition: edition, status: status)
   
                  }
               }
       }


    
    
}

//struct RequestsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestsPage(bookRequest: BookRequest)
//    }
//}

struct RequestHistoryRow: View {
    var request: BookRequest
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Book Name: \(request.bookName)")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("Author: \(request.author)")
                .font(.subheadline)
                .foregroundColor(.black)
            
            Text("Status: \(request.status == 0 ? "Requested" : (request.status == 1 ? "Approved" : "Rejected"))")
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
}
//
//struct Bookrequest: Identifiable { // Conforming to Identifiable
//    let id: UUID
//    let bookName: String
//    let author: String
//    let description: String?
//    let edition: String?
//    let status: Int
//}

//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//
//struct RequestsPage: View {
//    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
//    @State private var userEmail: String = ""
//    @State private var requestHistory : [BookRequest] = [] // Changed loanHistory to requestHistory
//
//    var body: some View {
//        if isLoggedIn {
//            NavigationStack {
//                ZStack {
//                    RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
//                        .ignoresSafeArea()
//
//                    VStack {
//                        Text("Request New Book")
//                            .foregroundColor(.white)
//                            .font(.title)
//                            .padding()
////                        Text("Logged in as: \(userEmail)")
////                            .foregroundColor(.white)
////                            .padding()
//
//                        List {
//                            ForEach(requestHistory) { request in
//                                RequestHistoryRow(request: request)
//                            }
//                        }
//                        .listStyle(PlainListStyle())
//                        .padding()
//                    }
//                }
//                .navigationBarBackButtonHidden(true)
//                .onAppear {
//                    fetchUserEmail()
//                    fetchRequestHistory()
//                }
//            }.navigationBarBackButtonHidden(true)
//        } else {
//            NavigationLink(destination: LoginView(), isActive: $isLoggedIn) {
//            }
//        }
//    }
//
//    func fetchUserEmail() {
//        if let currentUser = Auth.auth().currentUser {
//            userEmail = currentUser.email ?? "Unknown"
//            if let atIndex = userEmail.firstIndex(of: "@") {
//                userEmail = String(userEmail[..<atIndex])
//            }
//        }
//    }
//
//    func fetchRequestHistory() {
//        guard let userID = UserDefaults.standard.string(forKey: "userID") else { return }
//
//        let db = Firestore.firestore()
//
//        db.collection("requests")
//            .whereField("id", isEqualTo: userID)
////            .whereField("library_id", isEqualTo: "1")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching request history: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let documents = snapshot?.documents else {
//                    print("No request history found")
//                    return
//                }
//
//                self.requestHistory = documents.compactMap { document in
//                    guard let bookName = document["bookName"] as? String,
//                          let author = document["author"] as? String,
//                          let status = document["status"] as? Int else {
//                        // Ensure essential data is present
//                        return nil
//                    }
//
//                    // Optional properties
//                    let description = document["description"] as? String
//                    let edition = document["edition"] as? String
//                    print(bookName , status)
//                    return BookRequest(id: UUID(), bookName: bookName, author: author, description: description, edition: edition, status: status)
//
//                }
//            }
//    }
//
//
//    // Your other code remains the same
//}
//
//struct RequestsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestsPage()
//    }
//}
//
//struct RequestHistoryRow: View {
//    var request: BookRequest
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Book Name: \(request.bookName)")
//                .font(.headline)
//                .foregroundColor(.black)
//
//            Text("Author: \(request.author)")
//                .font(.subheadline)
//                .foregroundColor(.black)
//
//            Text("Status: \(request.status == 0 ? "Requested" : (request.status == 1 ? "Approved" : "Rejected"))")
//                .font(.subheadline)
//                .foregroundColor(.black)
//        }
//        .padding(.vertical, 10)
//        .padding(.horizontal)
//    }
//}
//
////struct Bookrequest: Identifiable { // Conforming to Identifiable
////    let id: UUID
////    let bookName: String
////    let author: String
////    let description: String?
////    let edition: String?
////    let status: Int
////}
