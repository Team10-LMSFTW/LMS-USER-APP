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
    
    var body: some View {
        NavigationView {
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
                                TextField("", text: $lastName)
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
            }
            .navigationBarBackButtonHidden(showAlert) // Hide the back button when showAlert is true
        }
    }
    
    func signUp() {
        // Your sign-up logic
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
