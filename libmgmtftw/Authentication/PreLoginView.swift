import SwiftUI

struct PreLoginView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("backgroundImage") // Add your image name here
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    Spacer()
                    VStack{
                        Spacer()
                        Spacer()
                        ZStack{
                            
                            VStack {
                                Text("Manage Your \nShelf with \nLibriLand")
                                    .font(.custom("SF Pro Display", size: 35).bold())
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(8)
                            }.padding(.top,160)
                            
                            
                            Button(action: {
                                // Add your login action here
                                
                            }) {
                                NavigationLink(destination: LoginView()) {
                                    Text("Login                                    ")
                                        .font(Font.custom("SF Pro Display", size: 20).bold()) // Use SF Pro font with size 18 and make it bold
                                    
                                        .foregroundColor(.white) // Make text color white
                                        .padding() // Add padding around the text
                                        .background(Color(hex: "503E88"))
                                }
                                
                            }
                            .background(Color(hex: "503E88"))
                            .cornerRadius(30)
                            .padding(.top,470)
                            
                            
                            Divider()
                                .background(Color.white)
                                .frame(maxWidth: 280)
                                .padding(.top,550)
                            
                            HStack {
                                Text("Don't have an account? ")
                                    .foregroundColor(.white)
                                    .padding(.top,580)
                                
                                NavigationLink(destination: SignUpView()) {
                                    Text("SignUp")
                                        .foregroundColor(.white)
                                        .underline()
                                        .padding(.top,580)
                                }
                            }
                            
                            
                        }
                        
                        Spacer()
                        
                    }
                    Spacer()
                }
            }
        }
            }
        }


#Preview {
    PreLoginView()
}
