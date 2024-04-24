
import SwiftUI
import FirebaseAuth

struct SignUpView: View {
   // @State private var isSignUpPage: Bool
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var phoneNumber: String = ""
    @State private var newPassword: String = ""
    @State private var gender: String = ""
    @State private var alertMessage = ""
    
    var body: some View {
        //NavigationView {
            ZStack{
                Image("BG2")
                    .resizable()
                    .scaledToFill()
                    .opacity(1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    HStack{
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Spacer()
                            
                            VStack{
                                
                                HStack{
                                    Text("First Name")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                }
                                TextField("", text: $firstName)
                                
                                    .cornerRadius(10.0)
                                    .background(Color.clear)
                                    .foregroundColor(.white)
                                    .padding(4)
                                
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                            .frame(width: 230)
                            VStack{
                                
                                HStack{
                                    Text("Last Name")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                }
                                TextField("", text:
                                            $lastName)
                                
                                .cornerRadius(10.0)
                                .background(Color.clear)
                                .foregroundColor(.white)
                                .padding(4)
                                
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            }
                            .frame(width: 230)
                            VStack{
                                HStack {
                                    Text("Email")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    
                                }
                                TextField("", text: $email)
                                
                                    .padding(4)
                                    .background(Color.clear)
                                    .cornerRadius(10.0)
                                    .foregroundColor(.white)
                                
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                
                                
                            }
                            .frame(width: 230)
                            VStack{
                                HStack {
                                    Text("Password")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Spacer()
                                    
                                }
                                SecureField("", text: $password)
                                
                                    .padding(4)
                                    .background(Color.clear)
                                    .cornerRadius(10.0)
                                    .foregroundColor(.white)
                                
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                
                            }
                            .frame(width: 230)
                            VStack{
                                HStack {
                                    Text("Confirm Password")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Spacer()
                                    
                                }
                                SecureField("", text: $confirmPassword)
                                
                                    .padding(4)
                                    .background(Color.clear)
                                    .cornerRadius(10.0)
                                    .foregroundColor(.white)
                                
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                
                            }
                            .frame(width: 230)
                            
                            
                            Spacer()
                        }
                        .padding(.vertical, 70)
                        .padding(.top, 30)
                    }
                    VStack{
                        
                        Button(action: {
                            signUp()
                            //isSignUpPage = false
                        }) {
                            Text("Sign Up ")
                                .font(Font.custom("SF Pro Display", size: 20).bold())
                            
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 250, height: 50)
                                .background(Color(hex: "503E88"))
                                .cornerRadius(30)
                        }
                        
                        NavigationLink(destination: LoginView()) {
                            
                            Text("Already have an account? Log in")
                                .foregroundColor(.white)
                                .underline()
                            
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                // Action for Google sign-in
                            }) {
                                Image("Google")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            .padding(.vertical, 20)
                            
                            Button(action: {
                                // Action for Apple sign-in
                            }) {
                                Image("Apple")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            .padding(.vertical, 20)
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                    }
                    
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
          //  }
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
                alertMessage = "Successfully Signed IN!"
                showAlert = true
                print("Sign up successful")
                // Navigate to the login page or perform any other action after successful sign up
            }
        }
    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
