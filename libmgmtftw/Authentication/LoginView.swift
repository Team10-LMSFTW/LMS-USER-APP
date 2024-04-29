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
        NavigationView { // Wrap the ZStack inside a NavigationView
            ZStack {
                Image("LibBG")
                    .resizable()
                    .scaledToFill()
                    .opacity(1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Spacer()
                    HStack {
                        Text("UserName")
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    TextField("", text: $email)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10.0)
                        .foregroundColor(.white)
                    
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    HStack {
                        Text("Password")
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    SecureField("", text: $password)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10.0)
                        .foregroundColor(.white)
                    
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    HStack {
                        Spacer()
                        Button(action: {
                            forgotPassword()
                        }) {
                            Text("Forgot Password?")
                                .foregroundColor(.white)
                                .underline()
                        }
                    }
                    
                    Button(action: { login() }) {
                        Text("Login                                    ")
                            .font(Font.custom("SF Pro Display", size: 20).bold())
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 250, height: 50)
                            .background(Color(hex: "503E88"))
                            .cornerRadius(30)
                    }
                    
                    Divider().background(Color.white).frame(maxWidth: 300)
                    
                    HStack {
                        Text("Don't have an account? ")
                            .foregroundColor(.white)
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("SignUp")
                                .foregroundColor(.white)
                                .underline()
                        }
                    }
                    VStack{
                        
                    }
                    .frame(height: 20)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                // Use NavigationLink to navigate to ExplorePageView when isLoggedIn is true
                NavigationLink(destination: ExplorePageView(userID: "", username: username), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true)
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
                // Set isLoggedIn to true after successful login to trigger navigation
                isLoggedIn = true
                // Fetch the username after successful login
                fetchUsername()
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
