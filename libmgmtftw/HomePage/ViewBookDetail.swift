import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Loans: Identifiable, Codable, Hashable {
    var id: String?
    var book_ref_id: String
    var user_id: String
    var lending_date: Timestamp
    var due_date: Timestamp
    var loan_status: String // Added property for loan_status
}
struct ViewBookDetail: View {
    @AppStorage("userID") private var userID: String = ""
    
    let bookID: String
    @State private var book: Books?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if let book = book {
                    BookHeaderView(book: book)
                    
                        VStack(alignment: .leading, spacing: 15){
                            BookDetailInfoView(book: book)
                    
                            BookDatesDetails(book:book)
                        }.padding(.vertical, 20)
                            .background(Color.primary.opacity(0.08))
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    
                } else {
                    
                        Text("Loading...")
                            .onAppear {
                                fetchData()
                            
                    }
                }
            }
        }.padding()
    }
        
    
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("books").document(bookID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            
            guard let document = snapshot, document.exists else {
                print("Document does not exist")
                return
            }

            do {
                self.book = try document.data(as: Books.self)
            } catch {
                print("Error decoding book data: \(error)")
            }
        }
    }
}

struct BookDatesDetails: View {
    let book: Books
    @State private var loanData: Loans?
    @AppStorage("userID") private var userID: String = ""
    
    var body: some View {
       
        VStack(alignment: .leading, spacing: 10) {
            if let loanData = loanData {
                Text("Lending Date: \(formattedDate(from: loanData.lending_date))").font(.subheadline)
                Text("Due Date: \(formattedDate(from: loanData.due_date))").font(.subheadline)
                Text("Loan Status: \(loanData.loan_status)").font(.subheadline)
            } else {
                Text("Loading...")
                    .onAppear {
                        fetchData()
                    }
            }
        }
        .padding()
        //.font(.title3)
        //.padding()
    }
    
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .whereField("book_ref_id", isEqualTo: book.id ?? "BcrcDX6ehZ0GJloskQnF")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching loan documents: \(error)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("Loan document not found")
                    return
                }
                
                do {
                    self.loanData = try document.data(as: Loans.self)
                } catch {
                    print("Error decoding loan data: \(error)")
                }
            }
    }
    
    private func formattedDate(from timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy" // Customize the date format as needed
        return dateFormatter.string(from: timestamp.dateValue())
    }
}

// Preview for SwiftUI Canvas
struct ViewBookDetail_Previews: PreviewProvider {
    static var previews: some View {
        ViewBookDetail(bookID: "your_book_id_here")
    }
}
