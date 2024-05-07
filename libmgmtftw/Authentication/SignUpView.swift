import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var successMessage = ""
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userID") private var userID: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.black.ignoresSafeArea()
                
                VStack( alignment: .leading, spacing: 15){
                    HStack{
                        Text("Create New Account")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        Image(systemName: "lock")
                    }
                    
                    HStack {
                        Text("First Name")
                            .foregroundColor(.white)
                            .font(.footnote)
                        
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.white)
                            .padding(.leading, 10) // Adjust the padding as needed
                        
                        TextField("First name", text: $firstName)
                            .padding(.horizontal, 10) // Adjust the padding as needed
                            .padding(.vertical, 8) // Adjust the padding as needed
                            .foregroundColor(.white)
                            .accentColor(.white)
                    }.frame(width: 360, height: 50)
                        .background(Color.secondary.opacity(0.3))
                        .cornerRadius(10.0)
                   
                    HStack {
                        Text("Last Name")
                            .foregroundColor(.white)
                            .font(.footnote)
                        
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.white)
                            .padding(.leading, 10) // Adjust the padding as needed
                        
                        TextField("Last name", text: $lastName)
                            .padding(.horizontal, 10) // Adjust the padding as needed
                            .padding(.vertical, 8) // Adjust the padding as needed
                            .foregroundColor(.white)
                            .accentColor(.white)
                    }.frame(width: 360, height: 50)
                        .background(Color.secondary.opacity(0.3))
                        .cornerRadius(10.0)
                    
                 
                    HStack {
                        Text("UserName")
                            .foregroundColor(.white)
                            .font(.footnote)
                            
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.white)
                            .padding(.leading, 10) // Adjust the padding as needed

                        TextField("Email/Username", text: $email)
                            .padding(.horizontal, 10) // Adjust the padding as needed
                            .padding(.vertical, 8) // Adjust the padding as needed
                            .foregroundColor(.white)
                            .accentColor(.white)
                    }.frame(width: 360, height: 50)
                        .background(Color.secondary.opacity(0.3))
                    .cornerRadius(10.0)
                        
                    
                    HStack {
                        Text("Password")
                            .foregroundColor(.white)
                            .font(.footnote)
                            
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.white)
                            .padding(.leading, 10) // Adjust the padding as needed
                        SecureField("", text: $password)
                            .padding()
                            .foregroundColor(.white)
                            .accentColor(.white)
                    }.frame(width: 360, height: 50)
                        .background(Color.secondary.opacity(0.3))
                    .cornerRadius(10.0)
                    .padding(.bottom,10)
                    
                    
                    HStack {
                        Text("Confirm Password")
                            .foregroundColor(.white)
                            .font(.footnote)
                            
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.white)
                            .padding(.leading, 10) // Adjust the padding as needed
                        SecureField("", text: $confirmPassword)
                            .padding()
                            .foregroundColor(.white)
                            .accentColor(.white)
                    }.frame(width: 360, height: 50)
                        .background(Color.secondary.opacity(0.3))
                    .cornerRadius(10.0)
                    .padding(.bottom,10)
                
                    
                    Divider().background(Color.secondary).frame(maxWidth: 400)
                    
                    
                    VStack(spacing:25) {
                        
                        Button(action: {
                            signUp()
                        }) {
                            Text("Sign Up ")
                                .font(Font.custom("SF Pro Display", size: 20).bold())
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 360, height: 50)            .background(Color(hex:"FD5F00", opacity :1))
                                .cornerRadius(10)
                        }
                        
                        HStack {
                            Text("Already have an account ?")
                                .foregroundColor(.white)
                                
                            NavigationLink(destination: LoginView()) {
                                Text("Log In")
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                        }
                        
                    }
                    
                }
                .padding()
                .padding(.top, -50)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarBackButtonHidden(showAlert) // Hide the back button when showAlert is true
        }
    }
    
    func signUp() {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                print("Sign up error: \(error.localizedDescription)")
            } else if let result = result {
                successMessage = "Signed up successfully!"
                print("Sign up successful")
                let userID = result.user.uid // Get the user ID from the result
                
                // Create a new document in the users collection
                let db = Firestore.firestore()
                let userData: [String: Any] = [
                    "category_type": "Member",
                    "first_name": firstName,
                    "last_name": lastName,
                    "library_id": "1",
                    "membership_type": "free",
                    "rating": 5
                ]
                
                db.collection("users").document(userID).setData(userData) { error in
                    if let error = error {
                        print("Error adding user document: \(error.localizedDescription)")
                    } else {
                        print("User document added successfully")
                        updateCategoryType(userID: userID) // Update category_type after adding the document
                    }
                }
            }
        }
    }

    func updateCategoryType(userID: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        userRef.updateData(["category_type": "Member"]) { error in
            if let error = error {
                print("Error updating category_type: \(error.localizedDescription)")
            } else {
                print("category_type updated successfully")
            }
        }
    }

    
    func updateCategoryType() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        userRef.updateData(["category_type": "Member"]) { error in
            if let error = error {
                print("Error updating category_type: \(error.localizedDescription)")
            } else {
                print("category_type updated successfully")
            }
        }
    }
}
    
    struct SignUpView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpView()
        }
    }

