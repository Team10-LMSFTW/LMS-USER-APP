import SwiftUI
import Firebase

struct BookDetailsEntryView: View {
    @State private var showBarcodeScannerView = false
    @State private var scannedBarcode: String = ""
    @State private var author: String = ""
    @State private var bookName: String = ""
    @State private var category: String = ""
    @State private var coverURL: String = ""
    @State private var createdAt: Date = Date()
    @State private var libraryID: String = ""
    @State private var loanID: String = ""
    @State private var quantity: Int = 0
    @State private var thumbnailURL: String = ""
    @State private var totalQuantity: Int = 0
    @State private var isbn: String = ""
    @State private var scannedText: String = ""
    @AppStorage("userID")  var userIDMember: String = ""
    @State private var showAlert = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Book Details Entry")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.primary)
                        .padding(.top)
                    
                    HStack {
                        Text("ISBN:")
                            .font(.headline)
                            .foregroundColor(Color.primary)
                        Text(scannedBarcode.isEmpty ? isbn : scannedBarcode)
                    }
                    .padding(.horizontal)
                    
                    HStack (spacing: 20) {
                        
                        TextField("Enter ISBN", text: $scannedText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(Color.primary.opacity(0.08))
                            .padding(.leading)
                        
                        Button(action: {
                            fetchBookDetails()
                        }) {
                            Text("Fetch Book")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.6))
                                .cornerRadius(5)
                        }
                        .padding(.trailing)
                    }
                    
                    
                    
                    HStack {
                        Text("Scanned Text:")
                            .font(.headline)
                        Spacer()
                        Text(scannedText)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        showBarcodeScannerView.toggle()
                    }) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.primary.opacity(0.08))
                            .frame(width: 200, height: 100)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 2, y: 2)
                            .overlay (
                                VStack(alignment:.center, spacing: 15) {
                                    Image(systemName: "barcode.viewfinder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color(hex: "B3B3BD"))
                                    
                                    Text("Scan Barcode")
                                        .font(Font.custom("SF Pro", size: 15).weight(.bold))
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color(hex:"B3B3BC"))
                                        .frame(width: 150)
                                }
                                    .padding()
                                    .sheet(isPresented: $showBarcodeScannerView, onDismiss: {
                                        fetchBookDetails()
                                    }) {
                                        Content1View(scannedText: $scannedText)
                                    }
                            )
                    }
                    .padding(.leading, 80)
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Author Name:")
                            .font(.headline)
                        TextField("Enter Author Name", text: $author)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Book Name:")
                            .font(.headline)
                        TextField("Enter Book Name", text: $bookName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Category:")
                            .font(.headline)
                        TextField("Enter Category", text: $category)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cover URL:")
                            .font(.headline)
                        TextField("Enter Cover URL", text: $coverURL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Created At:")
                            .font(.headline)
                        DatePicker("", selection: $createdAt)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ISBN:")
                            .font(.headline)
                        TextField("Enter ISBN", text: $scannedText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    
                    //                    VStack(alignment: .leading, spacing: 10) {
                    //                        Text("Library ID:")
                    //                            .font(.headline)
                    //                        TextField("Enter Library ID", text: $libraryID)
                    //                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                    }
                    //                    .padding(.horizontal)
                    //
                    //                    VStack(alignment: .leading, spacing: 10) {
                    //                        Text("Loan ID:")
                    //                            .font(.headline)
                    //                        TextField("Enter Loan ID", text: $loanID)
                    //                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                    }
                    //                    .padding(.horizontal)
                    //
                    //                    VStack(alignment: .leading, spacing: 10) {
                    //                        Text("Quantity:")
                    //                            .font(.headline)
                    //                        TextField("Enter Available Quantity", value: $quantity, formatter: NumberFormatter())
                    //                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                            .keyboardType(.numberPad)
                    //                    }
                    //                    .padding(.horizontal)
                    //
                    //                    VStack(alignment: .leading, spacing: 10) {
                    //                        Text("Total Quantity:")
                    //                            .font(.headline)
                    //                        TextField("Enter Total Quantity", value: $totalQuantity, formatter: NumberFormatter())
                    //                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                            .keyboardType(.numberPad)
                    //                    }
                    //                    .padding(.horizontal)
                    //
                    //
                    //                    VStack(alignment: .leading, spacing: 10) {
                    //                        Text("Thumbnail URL:")
                    //                            .font(.headline)
                    //                        TextField("Enter Thumbnail URL", text: $coverURL)
                    //                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                    }
                    //                    .padding(.horizontal)
                    
                    Button(action: {
                        saveBookDetails()
                    }) {
                        Text("Save Book Details")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.opacity(0.6))
                            .cornerRadius(10)
                    }
                    .padding(.leading, 100)
                    .alert(isPresented: $showAlert) {
                                            Alert(title: Text("Request Raised"),
                                                  message: Text("Your Request has been raised!"),
                                                  dismissButton: .default(Text("OK")))
                                        }
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
    private func fetchBookDetails() {
        guard !scannedText.isEmpty else {
            return
        }
        
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(scannedText)&key=AIzaSyAwg3k9Z2axowORtmqmkpjZZBkdEvPmU5A") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching book details: \(error)")
                return
            }
            
            if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(dataString)") // Print the response data
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonResponse = json as? [String: Any],
                       let items = jsonResponse["items"] as? [[String: Any]],
                       let volumeInfo = items.first?["volumeInfo"] as? [String: Any] {
                        DispatchQueue.main.async {
                            if let authors = volumeInfo["authors"] as? [String] {
                                self.author = authors.joined(separator: ", ")
                            } else {
                                self.author = ""
                            }
                            
                            self.bookName = volumeInfo["title"] as? String ?? ""
                            
                            if let categories = volumeInfo["categories"] as? [String] {
                                self.category = categories.joined(separator: ", ")
                            } else {
                                self.category = ""
                            }
                            
                            if let thumbnailURL = volumeInfo["imageLinks"] as? [String: String],
                               let imageURL = thumbnailURL["thumbnail"] {
                                self.coverURL = imageURL
                            } else {
                                self.coverURL = ""
                            }
                        }
                    }
                } catch {
                    print("Error parsing book details: \(error)")
                }
            }
        }.resume()
    }
    
    private func saveBookDetails() {
        let db = Firestore.firestore()
        print(userIDMember)
        let requestData: [String: Any] = [
            "user_id": userIDMember,
            "name": bookName,
            "author": author,
            "description": "",
            "edition": "",
            "status": 0,
            "category": category,
            "library_id": "1"
        ]
        
        db.collection("requests").addDocument(data: requestData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Request added successfully")
                
                // Clear the fields after saving
                author = ""
                bookName = ""
                category = ""
                coverURL = ""
                createdAt = Date()
                isbn = ""
                self.showAlert = true
            }
        }
    }
}

struct BookDetailsEntryView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailsEntryView()
    }
}
