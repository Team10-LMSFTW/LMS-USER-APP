import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: { login() }) {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                Button(action: { forgotPassword() }) {
                    Text("Forgot Password?")
                        .foregroundColor(.blue)
                }
                .padding(.top)
                
                Spacer()
                
                HStack {
                    Spacer()
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign up")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                if showAlert {
                    Text(alertMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                print("Login error: \(error.localizedDescription)")
            } else {
                print("Login successful")
                
                // Navigate to the next screen or perform any other action after successful login
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
