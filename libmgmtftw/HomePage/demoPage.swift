import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct demoPage: View {
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var userEmail: String = ""
    @State private var loanHistory: [LoanHistory] = []
    
    var body: some View {
        if isLoggedIn {
            NavigationStack {
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Welcome to Demo Page")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                        Text("Logged in as: \(userEmail)")
                            .foregroundColor(.white)
                            .padding()
                        
                        List {
                            ForEach(loanHistory) { history in
                                LoanHistoryRow(history: history)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding()
                        
                        Button(action: logout) {
                            Text("Logout")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    fetchUserEmail()
                    fetchLoanHistory()
                }
            }.navigationBarBackButtonHidden(true)
        } else {
            NavigationLink(destination: LoginView(), isActive: $isLoggedIn) {
                EmptyView()
            }
        }
    }
    
    func logout() {
        // Sign out the user
        do {
            try Auth.auth().signOut()
            
            // Reset the isLoggedIn flag and userID
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "userID")
            
            // Check if the app is being reinstalled or killed
            let isLoggedInSet = UserDefaults.standard.bool(forKey: "isLoggedIn")
            let userIDExists = UserDefaults.standard.string(forKey: "userID") != nil
            
            if !isLoggedInSet || !userIDExists {
                // Show the pre-login view if isLoggedIn flag or userID is not set
                // Here, you should navigate to the appropriate pre-login view
                // For demonstration, let's assume the destination is named PreLoginView
                // Replace PreLoginView() with your actual pre-login view
                let preLoginView = LoginView()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: preLoginView)
                    window.makeKeyAndVisible()
                }
            } else {
                // Show the login view
                // Here, you should navigate to the appropriate login view
                // For demonstration, let's assume the destination is named LoginView
                // Replace LoginView() with your actual login view
                let loginView = CarouselView()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: loginView)
                    window.makeKeyAndVisible()
                }
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
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
    
    func fetchLoanHistory() {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else { return }
        
        let db = Firestore.firestore()
        
        let dateFormatter = DateFormatter() // Define dateFormatter here
        
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching loan history: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No loan history found")
                    return
                }
                
                self.loanHistory = documents.compactMap { document in
                    guard let bookName = document["book_name"] as? String,
                          let lendingDateString = document["lending_date"] as? String,
                          let lendingDate = dateFormatter.date(from: lendingDateString) else {
                        
                        return nil
                    }
                    
                    return LoanHistory(bookName: bookName, lendingDateString: lendingDateString, lendingDate: lendingDate)
                    print("hi\(bookName)")
                }
                
            }
    }
    
    struct demoPage_Previews: PreviewProvider {
        static var previews: some View {
            demoPage()
        }
    }
    
    struct LoanHistoryRow: View {
        var history: LoanHistory
        
        var body: some View {
            HStack {
                
                VStack(alignment: .leading) {
                    Text(history.bookName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    
                    Text(history.lendingDateString)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 10)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    struct LoanHistory: Identifiable {
        let id = UUID()
        let bookName: String
        let lendingDateString: String
        let lendingDate: Date?
    }
}
