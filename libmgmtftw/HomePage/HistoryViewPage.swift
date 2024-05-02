import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HistoryViewPage: View {
    @State private var loanHistory: [LoanHistory] = []

    var body: some View {
        NavigationView {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Borrowed Books History")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    List(loanHistory) { history in
                        LoanHistoryRow(history: history)
                    }
                    .listStyle(PlainListStyle())
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                fetchLoanHistory()
            }
        }
    }
    
    func fetchLoanHistory() {
        let db = Firestore.firestore()
        
        db.collection("loans")
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    if let error = error {
                        print("Error fetching loan history: \(error.localizedDescription)")
                    } else {
                        print("No loan history found")
                    }
                    return
                }
                
                for document in snapshot.documents {
                    guard let bookRefID = document["book_ref_id"] as? String,
                          let lendingDateString = document["lending_date"] as? String else {
                        continue
                    }
                    
                    // Fetch book information based on book reference ID
                    db.collection("books").document(bookRefID).getDocument { bookDocument, error in
                        if let error = error {
                            print("Error fetching book information: \(error.localizedDescription)")
                            return
                        }
                        
                        if let bookData = bookDocument?.data(),
                           let bookName = bookData["book_name"] as? String {
                            let loanHistoryItem = LoanHistory(bookName: bookName, bookRefID: bookRefID, lendingDateString: lendingDateString)
                            DispatchQueue.main.async {
                                self.loanHistory.append(loanHistoryItem)
                            }
                        } else {
                            print("Book information not found for bookRefID: \(bookRefID)")
                        }
                    }
                }
            }
    }
}

struct HistoryViewPage_Previews: PreviewProvider {
    static var previews: some View {
        HistoryViewPage()
    }
}

struct LoanHistoryRow: View {
    var history: LoanHistory
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(history.bookName)
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Book Ref ID: \(history.bookRefID)")
                .font(.subheadline)
                .foregroundColor(.white)
            
            Text("Lending Date: \(history.lendingDateString)")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
    }
}

struct LoanHistory: Identifiable {
    let id = UUID()
    let bookName: String
    let bookRefID: String
    let lendingDateString: String
}
