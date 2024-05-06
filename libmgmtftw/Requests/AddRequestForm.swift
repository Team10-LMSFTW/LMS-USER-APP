import SwiftUI
import Firebase
import Foundation

struct BookRequest: Identifiable {
//    var id: ObjectIdentifier
//    // Conforming to Identifiable
    let id: UUID
    let name: String
    let author: String
    let description: String?
    let edition: String?
    let status: Int
    let category: String?
    let library_id : String?
//    let category: String
//    let library_id : String
    
}
struct RequestsaddView: View {
    
    @State private var bookName = ""
    @State private var author = ""
    @State private var description = ""
    @State private var edition = ""
    @State private var status = 0
    @State private var category = ""
    @State private var bookRequest: BookRequest
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userID") private var userID: String = ""

    init(bookRequest: BookRequest = BookRequest(id: UUID(),name: "", author: "", description: nil, edition: nil, status: 0,category: "",library_id: "1")) {
        _bookRequest = State(initialValue: bookRequest)
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                Color.black.ignoresSafeArea()
                
                VStack {
                    Group {
                        FieldView(placeholder: "Book Name", text: $bookName)
                        FieldView(placeholder: "Author", text: $author)
                        FieldView(placeholder: "Description", text: $description)
                        FieldView(placeholder: "Edition", text: $edition)
                        FieldView(placeholder: "Category", text: $category)
                    }
                    
                    Button(action:{
                        let db = Firestore.firestore()
                        db.collection("requests").addDocument(data: [
                            "user_id": userID,
                            "name": self.bookName,
                            "author": self.author,
                            "description": self.description,
                            "edition": self.edition,
                            "status": self.status,
                            "category":self.category,
                            "library_id":"1"
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added successfully")
                            }
                        }
                    }) {
                        Text("Submit")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(hex:"FD5F00", opacity :0.8))
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding()
                //                .background(Color.black)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Add Book Request").foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    struct FieldView: View {
        let placeholder: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(placeholder)
                    .foregroundColor(.white)
                    .font(.footnote)
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .accentColor(.white)
                    .padding(.horizontal, 10) // Adjust the padding as needed
                    .padding(.vertical, 8) // Adjust the padding as needed
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10.0)
                    .padding(.bottom, 10)
            }
        }
    }
}
