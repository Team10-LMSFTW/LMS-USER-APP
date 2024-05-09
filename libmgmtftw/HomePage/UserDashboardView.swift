//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//
//struct UserDashboardView: View {
//    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
//    @State private var userEmail: String = ""
//    @State private var loanHistory: [LoanHistory] = []
//    @AppStorage("userID") private var userID: String = ""
//    @State private var booksBorrowed: Int = 0
//    @State private var totalPendingPenalty: Int = 0
//    @State private var showSignInView = false
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
//                    .ignoresSafeArea()
//                ScrollView{
//                    VStack(alignment: .leading, spacing: 20) {
//                        HStack {
//                            Text("Home")
//                                .font(.largeTitle)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                                .padding(.leading, 100)
//                            
//                            Spacer()
//                            
//                            NavigationLink(destination: SettingsView(showSignInView: $showSignInView)) {
//                                Image(systemName: "gearshape")
//                                    .font(.title2)
//                                    .foregroundColor(.white)
//                                    .padding(.trailing, 100)
//                            }
//                        }
//                        .padding(.top, 20)
//                        
//                        // Top rectangle
//                        VStack(spacing: 12) {
//                            HStack(spacing: 12) {
//                                Spacer()
//                                NavigationLink(destination: HistoryPage(selection: <#Binding<Int?>#>)) {
//                                    DashboardItem(title: "Books Read", value: "\(booksBorrowed)", color: Color.green)
//                                }
//                                Spacer()
//                                NavigationLink(destination: HistoryPage()) {
//                                    DashboardItem(title: "Books Borrowed", value: "\(booksBorrowed)", color: Color.blue)
//                                }
//                                Spacer()
//                            }.padding()
//                            
//                            HStack(spacing: 12) {
//                                Spacer()
//                                DashboardItem(title: "Penalty Due", value: "\(totalPendingPenalty)", color: Color.red)
//                                Spacer()
//                                NavigationLink(destination: ExplorePageView(userID: "", username: "")) {
//                                    DashboardItem(title: "New Books", value: "", color: Color.orange, systemImage: "arrowshape.right.fill")
//                                }
//                                Spacer()
//                            }.padding()
//                        }
//                        .padding(20)
//                        .background(Color(hex: "#000000", opacity: 0.4))
//                        .cornerRadius(25)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 20)
//                        
//                        Spacer()
//                        
//                       
//                    }
//                    
//                    .navigationBarBackButtonHidden(true)
//                    .onAppear {
//                        fetchUserEmail()
//                        fetchBooksBorrowed()
//                        fetchTotalPendingPenalty()
//                    }
//                }
//            }
//        }
//    }
//    
//    
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
//    func fetchBooksBorrowed() {
//        let db = Firestore.firestore()
//        
//        db.collection("loans")
//            .whereField("user_id", isEqualTo: userID)
//            .getDocuments { (snapshot, error) in
//                if let error = error {
//                    print("Error fetching loans: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let documents = snapshot?.documents else {
//                    print("No loan documents found")
//                    return
//                }
//                booksBorrowed = documents.count
//                print("Number of books borrowed: \(documents.count)")
//            }
//    }
//    
//    func fetchTotalPendingPenalty() {
//        let db = Firestore.firestore()
//        
//        db.collection("loans")
//            .whereField("user_id", isEqualTo: userID)
//            .whereField("loan_status", isEqualTo: "active")
//            .getDocuments { (snapshot, error) in
//                if let error = error {
//                    print("Error fetching loans: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let documents = snapshot?.documents else {
//                    print("No loan documents found")
//                    return
//                }
//                
//                let currentDate = Date()
//                
//                for document in documents {
//                    if let dueDateString = document["due_date"] as? String,
//                       let dueDate = ISO8601DateFormatter().date(from: dueDateString) {
//                        let daysOverdue = Calendar.current.dateComponents([.day], from: dueDate, to: currentDate).day ?? 0
//                        let penaltyAmount = Int(daysOverdue * 30)
//                        totalPendingPenalty += penaltyAmount
//                    }
//                }
//                
//                print("Total pending penalty amount: \(totalPendingPenalty)")
//            }
//    }
//}
//
//struct UserDashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDashboardView()
//    }
//}
//
//struct DashboardItem: View {
//    var title: String
//    var value: String
//    var color: Color
//    var systemImage: String?
//    
//    var body: some View {
//        VStack {
//            Text(title)
//                .font(.headline)
//                .foregroundColor(.white)
//            if let systemImage = systemImage {
//                Image(systemName: systemImage)
//                    .font(.system(size: 60))
//                    .foregroundColor(.white)
//            } else {
//                Text(value)
//                    .font(.system(size: 60))
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//            }
//        }
//        .padding(20)
//        .frame(width: 180, height: 180)
//        .background(color.opacity(0.4))
//        .cornerRadius(10)
//    }
//}
