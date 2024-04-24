import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    @State var isSignUpPage: Bool = false
    //@State private var isForgotPasswordPage = false
    
    var body: some View {
        //NavigationView {
            ZStack{
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
                            //isForgotPasswordPage = true
                        }) {
                            Text("Forgot Password?")
                                .foregroundColor(.white)
                                .underline()
                        }
                    }
                    
                    Button(action: { login()
                        
                    }) {
                        Text("Login                                    ")
                            .font(Font.custom("SF Pro Display", size: 20).bold())
                        
                            .foregroundColor(.white)                             .padding()
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
//                                .onTapGesture {
//                                    isSignUpPage = true
//                                }
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
                .navigationBarBackButtonHidden(true)
            }
//            .sheet(isPresented: $isForgotPasswordPage) {
//                ForgotPasswordView2(isForgotPasswordPage: $isForgotPasswordPage)
//            }
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
