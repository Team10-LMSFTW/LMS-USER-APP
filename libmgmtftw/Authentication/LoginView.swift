import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var showAlert: Bool = false
    @State var isLoggedIn: Bool = false
    @State var alertMessage: String = ""
    @State var username: String = "" // Add a state variable to store the username
    
    var body: some View {
        NavigationStack { // Wrap the ZStack inside a NavigationView
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Welcome ! 🙋🏻‍♂️")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                    }
                    
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
                    }
                    .frame(width: 360, height: 50)
                    .background(Color(hex: "AFAFB3", opacity: 0.4))
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
                    }
                    .frame(width: 360, height: 50)
                    .background(Color(hex: "AFAFB3", opacity: 0.4))
                    .cornerRadius(10.0)
                    .padding(.bottom, 10)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            forgotPassword()
                        }) {
                            Text("Forgot Password ?")
                                .foregroundColor(.white)
                                .font(.footnote)
                                .underline()
                        }
                    }
                    
                    Divider()
                        .background(Color.white)
                        .frame(maxWidth: 400)
                        .padding(.bottom,45)
                    
                    
                    VStack(spacing: 25) {
                       
                            Button(action: { login() }) {
                                Text("Login")
                                    .font(Font.custom("SF Pro Display", size: 20).bold())
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 360, height: 50)
                                    .background(Color(hex:"FD5F00", opacity :1))
                                    .cornerRadius(10)
                            }
                        NavigationLink(destination: Tab_Bar(), isActive: $isLoggedIn) {
                            EmptyView()
                        }

                        
                        HStack {
                            Text("Don't have an account ?")
                                .foregroundColor(.white)
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                        }
                    }
                    .frame(height: 20)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            // Check if the user is already logged in
            if Auth.auth().currentUser != nil {
                isLoggedIn = true
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                print("Login error: \(error.localizedDescription)")
            } else {
                print("Login successful")
                // Set UserDefaults flag
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                // Fetch the username after successful login
                fetchUsername()
                // Set isLoggedIn to true after successful login to trigger navigation
                withAnimation {
                    isLoggedIn = true
                }
            }
        }
    }


    
    func forgotPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                print("Forgot password error: \(error.localizedDescription)")
            } else {
                alertMessage = "Password reset email sent. Please check your inbox."
                showAlert = true
                print("Password reset email sent")
            }
        }
    }
    
    func fetchUsername() {
        // Fetch the username from Firestore or another database using the email address
        // For demonstration purposes, let's assume you have a Firestore collection named "users" with documents where the email is stored as "email" field and username as "username" field
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching username: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found for the email: \(email)")
                return
            }
            
            // Assuming there's only one document for each email
            if let document = documents.first {
                if let username = document["username"] as? String {
                    self.username = username
                    print("Fetched username: \(username)")
                } else {
                    print("Username not found in document")
                }
            } else {
                print("No document found for the email: \(email)")
            }
            //anvit@gmail.com
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
