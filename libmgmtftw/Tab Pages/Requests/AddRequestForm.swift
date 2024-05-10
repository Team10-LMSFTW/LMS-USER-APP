import SwiftUI
import Firebase

struct BookRequest: Identifiable {
    let id: UUID
    let name: String
    let author: String
    let description: String?
    let edition: String?
    let status: Int
    let category: String?
    let library_id: String?
}

struct RequestsaddView: View {
    
    @State private var bookName = ""
    @State private var author = ""
    @State private var description = ""
    @State private var edition = ""
    @State private var category = ""
    @State private var bookRequest: BookRequest
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userID") private var userID: String = ""
    
    init(bookRequest: BookRequest = BookRequest(id: UUID(), name: "", author: "", description: nil, edition: nil, status: 0, category: "", library_id: "1")) {
        _bookRequest = State(initialValue: bookRequest)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                //Color.primary
                    //.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Add Book Request")
                        .font(.title)
                        .foregroundColor(.primary)
                    
                    TextFieldWithTitle(placeholder: "Book Name", text: $bookName)
                    TextFieldWithTitle(placeholder: "Author", text: $author)
                    TextFieldWithTitle(placeholder: "Description", text: $description)
                    TextFieldWithTitle(placeholder: "Edition", text: $edition)
                    TextFieldWithTitle(placeholder: "Category", text: $category)
                    
                    Button(action: {
                        submitRequest()
                    }) {
                        Text("Submit")
                            .padding()
                            .foregroundColor(.primary)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .navigationBarTitle("Add Book Request", displayMode: .inline)
            }
        }
    }
    
    func submitRequest() {
        let db = Firestore.firestore()
        db.collection("requests").addDocument(data: [
            "user_id": userID,
            "name": bookName,
            "author": author,
            "description": description,
            "edition": edition,
            "status": 0,
            "category": category,
            "library_id": "1"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added successfully")
            }
        }
    }
}

struct TextFieldWithTitle: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(placeholder)
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("", text: $text)
                .padding()
                .foregroundColor(.primary)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10.0)
        }
    }
}

struct RequestsaddView_Previews: PreviewProvider {
    static var previews: some View {
        RequestsaddView()
    }
}
