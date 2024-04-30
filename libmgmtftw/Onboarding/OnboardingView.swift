import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct CarouselView: View {
    @State private var selection = 0
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userID") private var userID: String = ""

   // @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")

    let onboardingScreens: [(imageName: String, primaryText: String, secondaryText: String)] = [
        ("Onboarding1", "The Best Way to manage books", "Navigate Your Library World with \nLibriLand: Where Every Book \nFinds Its Place!"),
        ("Onboarding2", "Endless Adventures Await!", "Explore a World of Stories and Ideas,\n Where Your Imagination \nKnows No Bounds."),
        ("Onboarding3", "Elevate Your Experience!", "Embark on a Quest for Knowledge, Where\n Every Page Turn \nUnveils Something New.")
    ]

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                Tab_Bar()
            } else {
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                        .ignoresSafeArea()

                    TabView(selection: $selection) {
                        ForEach(onboardingScreens.indices, id: \.self) { index in
                            let screen = onboardingScreens[index]
                            OnboardingScreen(imageName: screen.imageName, primaryText: screen.primaryText, secondaryText: screen.secondaryText)
                                .tag(index)
                        }
                    }
                    .foregroundColor(Color(hex: "AFAFB3"))
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .padding(.top, -130)

                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            if scene.activationState == .background {
                                selection = (selection + 1) % onboardingScreens.count
                            }
                        }
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            if selection == onboardingScreens.count - 1 {

                                NavigationLink(destination: LoginView()) {
                                    Text("Get Started               ")
                                        .font(Font.custom("SF Pro Display", size: 20).bold())
                                        .foregroundColor(.black)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color(hex: "FD5F00"))
                                }
                                .cornerRadius(50)
                                .padding(.top, 320)
                                .shadow(radius: 10)

                            } else {
                                Button(action: {
                                    // Navigate to the next onboarding screen
                                    selection += 1
                                }) {
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 20)
                                        .background(Color(hex: "FD5F00"))

                                }
                                .cornerRadius(50)
                                .padding(.top, 390)
                                .shadow(radius: 10)
                            }
                            Spacer()
                        }
                    )
                }
            }
        }
        .onAppear {
            // Check if the user is already logged in
            isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
}


struct OnboardingScreen: View {
    let imageName: String
    let primaryText: String
    let secondaryText: String
    
    var body: some View {
        ZStack {
            //Color(hex: "14110F")
//            RadialGradient(gradient: Gradient(colors: [Color(hex: "3E2D30"), Color(hex: "14110F")]), center: .center, startRadius: 200, endRadius: 500)
          

            VStack {
                Text("LibriLand")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 80) // Adjust top padding
                
                Text(primaryText)
                    .font(.custom("SF Pro Display", size: 20).bold())
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40) // Adjust top padding
                
                Text(secondaryText)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top,30)
                    .multilineTextAlignment(.center)
                
                Spacer()
                Spacer()
            }
            .frame(width:380, height: 440)
            .background(Color(hex: "F6E8EA", opacity: 0.3))
            .cornerRadius(50)
            .padding(.top, 290)
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350, height: 330)
                .padding(.top, -340)
                .padding(.leading, 40)
            
        }
    }
}




struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
