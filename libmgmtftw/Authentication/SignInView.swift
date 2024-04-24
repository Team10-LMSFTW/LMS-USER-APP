//import SwiftUI
//import Firebase
//
//struct SignInView: View {
//    @State var firstName = ""
//    @State var lastName = ""
//    @State var email = ""
//    @State var password = ""
//    @State var confirmPassword = ""
//    @State var showAlert = false
//    @State var alertMessage = ""
//    @State var successMessage = ""
//    
//    var body: some View {
//        VStack {
//            TextField("First Name", text: $firstName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//                .opacity(firstName.isEmpty ? 0.5 : 1.0)
//                .disabled(firstName.isEmpty)
//            
//            TextField("Last Name", text: $lastName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//                .opacity(lastName.isEmpty ? 0.5 : 1.0)
//                .disabled(lastName.isEmpty)
//            
//            TextField("Email", text: $email)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            SecureField("Password", text: $password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            SecureField("Confirm Password", text: $confirmPassword)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            Button(action: { login() }) {
//                Text("Sign in")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding()
//            
//            Button(action: { signUp() }) {
//                Text("Sign up")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(10)
//            }
//            .padding()
//            
//            Button(action: { resetPassword() }) {
//                Text("Forgot Password?")
//                    .foregroundColor(.blue)
//            }
//            .padding()
//            
//           // if !successMessage.isEmpty {
//                Text(successMessage)
//                    .foregroundColor(.green) // Change text color to green
//                    .padding()
//                    .font(.headline) // Make the text larger
//                    .multilineTextAlignment(.center) // Center-align the text
//          //  }
//        }
//        .padding()
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//
//    func login() {
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                alertMessage = error.localizedDescription
//                showAlert = true
//                print("Login error: \(error.localizedDescription)")
//            } else {
//                successMessage = "Signed in successfully!"
//                print("Login successful")
//            }
//        }
//    }
//    
//    func signUp() {
//        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
//            alertMessage = "Please fill in all fields."
//            showAlert = true
//            return
//        }
//        
//        guard password == confirmPassword else {
//            alertMessage = "Passwords do not match."
//            showAlert = true
//            return
//        }
//        
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                alertMessage = error.localizedDescription
//                showAlert = true
//                print("Sign up error: \(error.localizedDescription)")
//            } else {
//                successMessage = "Signed up successfully!"
//                print("Sign up successful")
//            }
//        }
//    }
//    
//    func resetPassword() {
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//            if let error = error {
//                alertMessage = error.localizedDescription
//                showAlert = true
//                print("Reset password error: \(error.localizedDescription)")
//            } else {
//                successMessage = "Password reset email sent. Please check your inbox."
//                print("Password reset email sent")
//            }
//        }
//    }
//}
//
//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
