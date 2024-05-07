import SwiftUI
import Firebase
import FirebaseFirestoreSwift

// Define a model for the loan data
struct Loan: Identifiable, Codable, Hashable {
    var id: String?
    var book_ref_id: String
    var user_id: String
    var lending_date: Timestamp
    var book_name: String // Added property for book_name
    var cover_url: String // Added property for cover_url
    var loan_status: String // Added property for loan_status
}

// Create a SwiftUI view to display the list of loans
struct HistoryPage: View {
    @State private var loans: [Loan] = []
    @AppStorage("userID") private var userID: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
//                RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
//                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                   
                        
                        if loans.isEmpty {
                            Spacer()
                            Text("No history available")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.6))
                                .padding()
                        } else {
                            ForEach(loans) { loan in
                                LoanRow(loan: loan)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(20)
                }
                .onAppear {
                    // Fetch data from Firebase Firestore initially
                    fetchData()
                }
            }.navigationBarTitle("History")
        }
    }
    
    // Fetch data from Firebase Firestore
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                var allLoans: [Loan] = []
                
                for document in documents {
                    // Extracting data from Firestore document
                    let data = document.data()
                    
                    // Extracting individual fields
                    guard let bookRefID = data["book_ref_id"] as? String,
                          let lendingDateTimestamp = data["lending_date"] as? Timestamp,
                          let loanStatus = data["loan_status"] as? String else {
                        // Skip this document if any required field is missing
                        continue
                    }
                    
                    // Fetch book data based on book_ref_id
                    db.collection("books").document(bookRefID).getDocument { bookSnapshot, bookError in
                        if let bookError = bookError {
                            print("Error fetching book document: \(bookError)")
                            return
                        }
                        
                        guard let bookData = bookSnapshot?.data(),
                              let bookName = bookData["book_name"] as? String,
                              let coverURL = bookData["cover_url"] as? String else {
                            print("Book data not found.")
                            return
                        }
                        
                        // Create Loan object with book name, cover URL, and loan status
                        let loan = Loan(id: document.documentID, book_ref_id: bookRefID, user_id: userID, lending_date: lendingDateTimestamp, book_name: bookName, cover_url: coverURL, loan_status: loanStatus)
                        
                        // Append to the list of loans
                        allLoans.append(loan)
                        
                        // Sort the loans by lending date, latest first
                        allLoans.sort(by: { $0.lending_date.dateValue() > $1.lending_date.dateValue() })
                        
                        // Update the @State variable to trigger UI refresh
                        self.loans = allLoans
                    }
                }
            }
    }
}


struct LoanRow: View {
    var loan: Loan
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primary.opacity(0.08))
                .frame(width:350,height: 160)
                .padding(10)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
            HStack {
                RemoteImage2(url: loan.cover_url) // Display cover image
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 120)
                    .cornerRadius(10)
//                    .padding(.top)
//                    .padding(.trailing)
                
                VStack(alignment: .leading, spacing: 2){
                    Spacer()
                    Text("\(loan.book_name)") // Display book_name
                        .font(.title2)
                    .lineLimit(2)
                        .foregroundStyle(Color.white)
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(statusColor(for: loan.loan_status))
                            .frame(width:80,height: 20)
                            .padding(.horizontal, 8)
                        
                        Text("\(loan.loan_status)")
                            .font(.footnote)
                            .foregroundColor(.black)
                    }.padding(.leading,-15)
                    .padding(.top,-45)
                    
                    
                }
                Spacer()
                Text("\(formattedDate(from: loan.lending_date))")
                    .font(.subheadline)
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            //.background(Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.5))
            .cornerRadius(10)
        }
    }
    private func statusColor(for status: String) -> Color {
        switch status {
        case "due":
            return .red
        case "accepted":
            return .green
        
        case "active":
            return .green
        case "returned":
            return .pink
        case "rejected":
            return .red
        default:
            return .gray // Default color
        }
    }

    
    private func formattedDate(from timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy" // Format: Day Month Year (e.g., 01 Jan 2022)
        return dateFormatter.string(from: timestamp.dateValue())
    }
}

struct RemoteImage2: View {
    let url: String
    @State private var image: UIImage?

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .cornerRadius(2)
                .frame(width: 70, height: 110)
        } else {
            ProgressView()
                .foregroundColor(.white)
                .onAppear {
                    loadImage(from: url)
                }
        }
    }

    private func loadImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

// Preview for SwiftUI Canvas
struct HistoryPage_Previews: PreviewProvider {
    static var previews: some View {
        HistoryPage()
    }
}
