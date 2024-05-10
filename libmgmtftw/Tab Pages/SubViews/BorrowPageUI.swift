import SwiftUI
import Firebase

struct BorrowPageUI: View {
    @State private var selectedDate = Date()
    @State private var isConfirmed = false
    @State private var isAlertShown = false
    @State private var isDatePickerVisible = false
    @State private var book: Books?
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userID") private var userID: String = ""
    let bookID: String

    var body: some View {
        NavigationView {
            ZStack {
               // Color.black.ignoresSafeArea()
                
                VStack {
                    Text("Book Confirmation")
                        .font(.title)
                        .foregroundStyle(.primary)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Divider()
                        .background(Color.white)
                        .padding(.horizontal)
                        .padding(.bottom, 2)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            if let book = book {
                                BookHeaderView(book: book)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Select Date:")
                                        .foregroundStyle(.primary)
                                        .font(.headline)
                                    HStack {
                                        Text(selectedDate, style: .date)
                                            .foregroundStyle(.secondary)
                                        
                                        Spacer()
                                        Button(action: {
                                            isDatePickerVisible.toggle()
                                        }) {
                                            Image(systemName: "calendar")
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                    }
                                    if isDatePickerVisible {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.gray.opacity(0.2)) // Set the background color
                                            
                                            DatePicker("Select Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                                                .datePickerStyle(GraphicalDatePickerStyle())
                                                .labelsHidden()
                                                .padding(.horizontal)
                                                .colorScheme(.dark) // Set the color scheme to dark mode
                                                .accentColor(Color.blue) // Set the accent color to blue or any other desired color
                                        }
                                        .padding() // Add padding to adjust the layout
                                        .cornerRadius(10) // Apply corner radius to the RoundedRectangle
                                    }


                                }
                                .padding()
                                
                                Button(action: {
                                    // Call function to update loan information
                                    updateLoanInformation()
                                }) {
                                    Text(book.quantity > 0 ? "Confirm" : "Book isn't available")
                                        .foregroundColor(.primary)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity)
                                        .background(book.quantity > 0 ? Color(hex: "FD5F00", opacity: 0.8) : Color.red.opacity(0.2))
                                        .cornerRadius(8)
                                }
                                .padding()
                                .disabled(book.quantity == 0)
                            } else {
                                ProgressView() // Show loading indicator while fetching book details
                            }
                        }
                        .padding()
                    }
                }
            }
            .alert(isPresented: $isAlertShown) {
                if isConfirmed {
                    return Alert(title: Text("Booked"), message: Text("Your book has been successfully booked, ensure you collect your book!"), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Sorry"), message: Text("You already have requested or have borrowed this book!"), dismissButton: .default(Text("OK")))
                }
            }

            .onAppear {
                fetchData()
            }
        }
        .navigationBarHidden(true)
    }

    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("books").document(bookID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            
            guard let document = snapshot else {
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

    private func updateLoanInformation() {
        let db = Firestore.firestore()
        let lendingDate = selectedDate
        let dueDate = Calendar.current.date(byAdding: .day, value: 5, to: selectedDate) ?? selectedDate // Due date is 5 days from lending date
        
        // Retrieve userID from UserDefaults
        
        // Check if the user has already borrowed a book
        db.collection("loans")
            .whereField("user_id", isEqualTo: userID)
            .whereField("loan_status", isEqualTo: "active")
            .whereField("book_ref_id", isEqualTo: bookID)
            .getDocuments { (snapshot, error) in
                // Your existing code here
            

            guard let documents = snapshot?.documents else {
                print("Error fetching user loans: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if documents.isEmpty {
                // No active loans found for the user, proceed with borrowing
                
                // Start a Firestore transaction
                db.runTransaction({ (transaction, errorPointer) -> Any? in
                    do {
                        // Get the reference to the book document
                        let bookRef = db.collection("books").document(bookID)
                        
                        // Fetch the current book data within the transaction
                        let bookSnapshot = try transaction.getDocument(bookRef)
                        guard var bookData = bookSnapshot.data() else {
                            print("Document does not exist")
                            return nil
                        }
                        
                        // Check if the book quantity is greater than 0
                        guard let quantity = bookData["quantity"] as? Int else {
                            print("Quantity field not found")
                            return nil
                        }
                        
                        if quantity == 0 {
                            print("Book quantity is 0")
                            return nil
                        }
                        
                        // Update the book quantity by decrementing it by 1
                        bookData["quantity"] = quantity - 1
                        
                        // Update the book document with the new quantity
                        transaction.updateData(["quantity": bookData["quantity"] ?? 0], forDocument: bookRef)
                        
                        // Add loan data to Firestore loans collection
                        let loanData: [String: Any] = [
                            "book_ref_id": bookID,
                            "due_date": dueDate,
                            "lending_date": lendingDate,
                            "library_id": 1, // Default library ID
                            "loan_status": "requested",
                            "penalty_amount": 0,
                            "user_id": userID // Use the userID retrieved from UserDefaults
                        ]
                        
                        transaction.setData(loanData, forDocument: db.collection("loans").document()) // Add loan data
                        
                        return nil
                    } catch let fetchError {
                        // Handle fetch error
                        print("Error fetching document: \(fetchError)")
                        errorPointer?.pointee = NSError(domain: "FirestoreTransactionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error fetching document"])
                        return nil
                    } catch let updateError {
                        // Handle update error
                        print("Error updating document: \(updateError)")
                        errorPointer?.pointee = NSError(domain: "FirestoreTransactionError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error updating document"])
                        return nil
                    }
                }) { (object, error) in
                    if let error = error {
                        print("Transaction failed: \(error)")
                    } else {
                        print("Transaction succeeded")
                        isConfirmed = true // Show confirmation alert
                        isAlertShown = true // Show confirmation alert
                    }
                }
            } else {
                // User already has an active loan
                print("User already has an active loan")
                isAlertShown = true
                //isBorrowed = true
                // Show appropriate message to the user
            }
        }
    }


}

struct BorrowPageUI_Previews: PreviewProvider {
    static var previews: some View {
        BorrowPageUI(bookID: "example_book_id")
    }
}
