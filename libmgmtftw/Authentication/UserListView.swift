import SwiftUI
import Firebase
import FirebaseFirestoreSwift

// Step 1: Define a model for the user data
struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var first_name: String
    var gender: String
    // Add other user details as needed
}

// Step 2: Create a SwiftUI view to display the list of users
struct UserListView: View {
    @State private var users: [User] = []
    
    var body: some View {
        NavigationView {
            List(users) { user in
                VStack(alignment: .leading) {
                    Text(user.first_name)
                        .font(.headline)
                    Text(user.gender)
                        .font(.subheadline)
                    // Add other user details as needed
                }
            }
            .navigationTitle("Users List")
            .onAppear {
                // Step 3: Fetch data from Firebase Firestore initially
                fetchData()
            }
        }
    }
    
    // Step 3: Fetch data from Firebase Firestore
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                guard let documents = snapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                // Map Firestore documents to User objects
                self.users = documents.compactMap { document in
                    do {
                        let user = try document.data(as: User.self)
                        return user
                    } catch {
                        print("Error decoding document: \(error)")
                        return nil
                    }
                }
            }
        }
    }
}

// Preview for SwiftUI Canvas
struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
