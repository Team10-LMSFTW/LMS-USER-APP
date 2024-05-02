import SwiftUI
import Firebase

struct RequestsaddView: View {
    
    @State private var bookName = ""
    @State private var author = ""
    @State private var description = ""
    @State private var edition = ""
    @State private var status = 0
    @State private var category = ""
    @State private var bookRequest: BookRequest
    
    init(bookRequest: BookRequest = BookRequest(id: UUID(), bookName: "", author: "", description: nil, edition: nil, status: 0)) {
        _bookRequest = State(initialValue: bookRequest)
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                    .ignoresSafeArea()
                
                VStack {
                    Group {
                        FieldView(placeholder: "Book Name", text: $bookName)
                        FieldView(placeholder: "Author", text: $author)
                        FieldView(placeholder: "Description", text: $description)
                        FieldView(placeholder: "Edition", text: $edition)
//                        FieldView(placeholder: "Category", text: $category)
                    }
                    
                    Button(action:{
                        let db = Firestore.firestore()
                        db.collection("requests").addDocument(data: [
                            "id": UUID().uuidString,
                            "bookName": self.bookName,
                            "author": self.author,
                            "description": self.description,
                            "edition": self.edition,
                            "status": self.status,
//                            "category":self.category
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
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing)).ignoresSafeArea()
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 2.0, x: 2.0, y: 2.0)
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
