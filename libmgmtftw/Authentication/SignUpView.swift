import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var successMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack{
                RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                    .ignoresSafeArea()
                
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
                        .background(Color(hex: "AFAFB3", opacity: 0.4))
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
                        .background(Color(hex: "AFAFB3", opacity: 0.4))
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
                    }.frame(width: 360, height: 50)
                    .background(Color(hex: "AFAFB3", opacity: 0.4))
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
                    .background(Color(hex: "AFAFB3", opacity: 0.4))
                    .cornerRadius(10.0)
                    .padding(.bottom,10)
                
                    
                    Divider().background(Color.white).frame(maxWidth: 400)
                    
                    
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
            } else {
                successMessage = "Signed up successfully!"
                print("Sign up successful")
            }
        }
    }
}
    
    struct SignUpView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpView()
        }
    }

