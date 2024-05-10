import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RequestsPage: View {
    @AppStorage("userID") private var userID: String = ""
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var userEmail: String = ""
    @State private var requestHistory : [BookRequest] = []
    @State private var isPresentingChoiceBookPage: Bool = false
    @State private var bookRequest: BookRequest

    init(bookRequest: BookRequest = BookRequest(id: UUID(), name: "", author: "", description: nil, edition: nil, status: 0, category: "",library_id: "1")) {
        _bookRequest = State(initialValue: bookRequest)
    }

    var body: some View {
        if isLoggedIn {
            NavigationStack {
                ZStack {
                  //  Color.black.ignoresSafeArea()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Request")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                //.padding(.top, 20)
                                .padding()
//                            
//                            Spacer().frame(height: 10)
                            
                            if requestHistory.isEmpty {
                                Spacer()
                                Text("No requests pending, press Add(+) to make one today!")
                                    .font(.title3)
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .padding()
                            } else {
                                ForEach(requestHistory) { request in
                                    RequestHistoryRow(request: request)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                    }
                    
                    VStack {
                        Spacer()
                        VStack() {
                            Spacer()
                            Button(action: {
                                self.isPresentingChoiceBookPage = true
                            }) {
                                Image(systemName: "plus.square")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .padding()
                            }
                            .background(Color(hex:"FD5F00", opacity :0.8))
                            .cornerRadius(12)
                            .padding(.leading, 280)
                            .padding(.bottom, 20)
                            .sheet(isPresented: $isPresentingChoiceBookPage) {
                                BookDetailsEntryView()
                            }
                        }
                    }
                }//.navigationTitle("Requests")
                    .navigationBarTitleDisplayMode(.large)
                //.navigationBarBackButtonHidden(true)
                .onAppear {
                    fetchUserEmail()
                    fetchRequestHistory()
                }
            }
           // .navigationBarBackButtonHidden(true)
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
        let db = Firestore.firestore()
        
        db.collection("requests")
            .whereField("user_id", isEqualTo: userID)
            .whereField("library_id", isEqualTo: "1")
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
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let author = data["author"] as? String ?? ""
                    let status = data["status"] as? Int ?? 0
                    let category = data["category"] as? String ?? ""
                    let libraryID = data["library_id"] as? String ?? ""
                    let description = data["description"] as? String
                    let edition = data["edition"] as? String

                    return BookRequest(id: UUID(), name: name, author: author, description: description, edition: edition, status: status, category: category, library_id: libraryID)
                }
            }
    }
}


struct RequestHistoryRow: View {
    var request: BookRequest
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(request.name)") // Display book name
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                Text("by \(request.author)") // Display author
                    .font(.subheadline)
                    .foregroundStyle(Color.primary.opacity(0.7))
            }
            Spacer()
            Spacer()
            Spacer()
                ZStack {
                    let requestStatusString = requestStatusText(for: request.status)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(statusColor(for: requestStatusString))
                        .frame(width: 80, height: 20)

                    Text("\(requestStatusString)")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 8)
                .padding(.leading, 18)

        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color(hex: "AFAFB3", opacity: 0.2))
        .cornerRadius(10)
    }
    
    private func requestStatusText(for status: Int) -> String {
        switch status {
        case 0:
            return "Requested"
        case 1:
            return "Approved"
        default:
            return "Rejected"
        }
    }
    
    private func statusColor(for status: String) -> Color {
        switch status {
        case "Requested":
            return .yellow.opacity(0.8)
        case "Approved":
            return .green.opacity(0.8)
        default:
            return .red.opacity(0.8)
        }
    }

}

struct RequestsPage_Previews: PreviewProvider {
    static var previews: some View {
        RequestsPage()
    }
}
