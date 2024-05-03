import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserDashboardView: View {
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var userEmail: String = ""
    @State private var loanHistory: [LoanHistory] = []
    @AppStorage("userID") private var userID: String = ""
    @State private var booksBorrowed :Int = 0
    @State private var totalPendingPenalty : Int = 0 ;
    var body: some View {
        if true {
            NavigationStack {
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Your Analytics 📈")
                            .foregroundColor(Color.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        // top rectangle
                        ScrollView {
                            
                            RoundedRectangle(cornerRadius: 25.0)
                                .overlay(
                                    VStack(spacing: 5) {
                                        HStack() {
                                            VStack{
                                                Text("Books read").font(.headline).foregroundColor(.white)
                                                BooksRead()
                                            }.padding(10)
                                                .background(Color(hex: "AFAFB3", opacity: 0.4))
                                                .cornerRadius(10)
                                            
                                            Spacer()
                                            VStack{
                                                Text("Books Borrowed").font(.headline).foregroundColor(.white)
                                                Text("\(booksBorrowed)").font(.system(size: 95)).foregroundColor(.white).bold()
                                            }.padding(12)
                                                .background(Color(hex: "AFAFB3", opacity: 0.4))
                                                .cornerRadius(10)
                                        }.padding(20)
//                                         bottom two
                                        
                                        HStack(spacing: 10) {
                                            VStack{
                                                Text("Penalty Due").font(.headline).foregroundColor(.white)
                                                Text("\(totalPendingPenalty)").font(.system(size: 95)).foregroundColor(.white).bold()
                                            }.padding(20).frame(minWidth: 150)
                                                .background(Color(hex: "AFAFB3", opacity: 0.4))
                                                .cornerRadius(10)
                                            Spacer()
                                            Text("meow")
                                            //                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.orange)
                                                .cornerRadius(10)
                                            
                                        }.padding(20)
                                        
                                    }.padding(20).background(Color(hex: "151515", opacity: 1)).cornerRadius(25)
                                    
                                ).background(Color(hex: "ffff", opacity: 0))
                                .frame(minWidth: 400, minHeight: 400)
                                .padding(.horizontal, 50)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                            
                            Spacer()
                        }.background(Color(hex: "ffffff", opacity: 0)).padding(.horizontal, 100)
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
                    fetchBooksBorrowed()
                    fetchTotalPendingPenalty()
                }.navigationBarBackButtonHidden(true)
            } //else {
            //            NavigationLink(destination: LoginView(), isActive: $isLoggedIn) {
            //                Text("not logged in")
            //            }
            //        }
        }
    }
    func logout() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "userID")
            
            let isLoggedInSet = UserDefaults.standard.bool(forKey: "isLoggedIn")
            let userIDExists = UserDefaults.standard.string(forKey: "userID") != nil
            
            if !isLoggedInSet || !userIDExists {
                let preLoginView = LoginView()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: preLoginView)
                    window.makeKeyAndVisible()
                }
            } else {
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
    func fetchBooksBorrowed() {
        let db = Firestore.firestore()

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
                booksBorrowed = documents.count
                print("Number of books borrowed: \(documents.count)")
            }
    }
    
    func fetchTotalPendingPenalty() {
        let db = Firestore.firestore()
        
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .whereField("loan_status", isEqualTo: "active")
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
                    if let dueDateString = document["due_date"] as? String,
                       let dueDate = ISO8601DateFormatter().date(from: dueDateString) {
                        let daysOverdue = Calendar.current.dateComponents([.day], from: dueDate, to: currentDate).day ?? 0
                        let penaltyAmount = Int(daysOverdue * 30)
                        totalPendingPenalty += penaltyAmount
                    }
                }
                
                print("Total pending penalty amount: \(totalPendingPenalty)")
            }
    }


}

struct UserDashboardView_Previews: PreviewProvider {
    @State private var isLoggedIn: Bool = true
    @State private var userEmail: String = ""

    static var previews: some View {
        UserDashboardView()
    }
}


struct BooksRead: View {
    @State private var totalBooks: Double = 100
    @State private var booksRead: Double = 60
    @AppStorage("userID") private var userID: String = ""

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0, to: CGFloat(booksRead / totalBooks))
                    .stroke(Color.green, lineWidth: 15)
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .trim(from: CGFloat(booksRead / totalBooks), to: 1)
                    .stroke(Color.gray, lineWidth: 15)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(Int(booksRead))")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Divider()
                    
                    Text("\(Int(totalBooks))")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 95, height: 75)
            
        }
        .padding()
        .onAppear {
            fetchTotalBooksRead()
        }
    }



    func fetchTotalBooksRead() {
        let db = Firestore.firestore()
        var uniqueBooksRead : Set<String> = []

        // Fetch the total number of books
        db.collection("books")
            .whereField("library_id", isEqualTo: "1")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching books: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No book documents found")
                    return
                }
                print(documents)
                totalBooks = Double(documents.count)
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
                for document in documents {
                    if let bookRefId = document["book_ref_id"] as? String {
                        uniqueBooksRead.insert(bookRefId)
                    }
                }
                print(uniqueBooksRead)

                booksRead = Double(uniqueBooksRead.count)
            }
    }
}
