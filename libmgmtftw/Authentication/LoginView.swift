import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var username: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userID") private var userID: String = ""

    var body: some View {
        //NavigationView {
            ZStack {
               // Color.black.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Text("Welcome ! 🙋🏻‍♂️")
                                            .foregroundColor(.primary)
                                            .font(.largeTitle)
                                            .bold()
                                    }
                                    
                                    HStack {
                                        Text("UserName")
                                            .foregroundColor(.primary)
                                            .font(.footnote)
                                        Spacer()
                                    }
                                    HStack {
                                        Image(systemName: "envelope")
                                            .foregroundColor(.secondary)
                                            .padding(.leading, 10) // Adjust the padding as needed
                                        TextField("Email/Username", text: $email)
                                            .padding(.horizontal, 10) // Adjust the padding as needed
                                            .padding(.vertical, 8) // Adjust the padding as needed
                                            .foregroundColor(.primary.opacity(0.5))
                                            .accentColor(.white)
                                    }
                                    .frame(width: 360, height: 50)
                                    .background(Color.secondary.opacity(0.3))
                                    .cornerRadius(10.0)
                                    
                                    HStack {
                                        Text("Password")
                                            .foregroundColor(.primary)
                                            .font(.footnote)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Image(systemName: "lock")
                                            .padding(.leading, 10)
                                            .foregroundColor(.secondary)
                                        
                                        SecureField("Password", text: $password)
                                            .padding()
                                            .foregroundColor(.primary.opacity(0.5))
                                            .accentColor(.white)
                                    }
                                    .frame(width: 360, height: 50)
                                    .background(Color.secondary.opacity(0.3))
                                    .cornerRadius(10.0)
                                    .padding(.bottom, 10)
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            forgotPassword()
                                        }) {
                                            Text("Forgot Password ?")
                                                .foregroundColor(.primary)
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
                                                .foregroundColor(.primary)
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
        
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if isLoggedIn {
                // Navigate to the tab bar view if already logged in
                // Here, you can use the appropriate destination for your tab bar view
                // For demonstration, let's assume the destination is named TabBarView
                // Replace TabBarView() with your actual tab bar view
                let tabBarView = Tab_Bar()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: tabBarView)
                    window.makeKeyAndVisible()
                }
            }
            }
        //}
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
                
                // Store userID in @AppStorage
                userID = result?.user.uid ?? ""
                print("\(userID)")
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
            
            if let document = documents.first {
                if let username = document["username"] as? String {
                    self.username = username
                    print("Fetched username: \(username)")
                    // Save the username to UserDefaults
                    UserDefaults.standard.set(username, forKey: "username")
                } else {
                    print("Username not found in document")
                }
            } else {
                print("No document found for the email: \(email)")
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
