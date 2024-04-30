import SwiftUI

struct CarouselView: View {
@State private var selection = 0

let onboardingScreens: [(imageName: String, primaryText: String, secondaryText: String)] = [
    ("Onboarding1", "The Best Way to manage books", "Navigate Your Library World with \nLibriLand: Where Every Book \nFinds Its Place!"),
    ("Onboarding2", "Endless Adventures Await!", "Explore a World of Stories and Ideas,\n Where Your Imagination \nKnows No Bounds."),
    ("Onboarding3", "Elevate Your Experience!", "Embark on a Quest for Knowledge, Where\n Every Page Turn \nUnveils Something New.")
]

var body: some View {
    NavigationView{
        ZStack {
            Color(hex: "14110F").edgesIgnoringSafeArea(.all) // Set background color
            
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
            
            //.edgesIgnoringSafeArea(.all)
            .padding(.top, -50) // Move the TabView slider up by 50 points
            
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
                        
                        NavigationLink(destination: PreLoginView()) {
                            Text("Get Started               ")
                                .font(Font.custom("SF Pro Display", size: 20).bold())
                                .foregroundColor(.black)// Use SF Pro font with size 18 and make it bold
                            
                                .foregroundColor(.white) // Make text color white
                                .padding() // Add padding around the text
                                .background(Color(hex: "FD5F00"))
                                
                            
                        }
                        .cornerRadius(50)
                        //.padding(.bottom, 30) // Adjust bottom padding
                        .padding(.top, 320) // Adjust top padding
                        .shadow(radius: 10)
                        
                    } else {
                        Button(action: {
                            // Navigate to the next onboarding screen
                            selection += 1
                        }) {
                            Image(systemName: "arrow.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35) // Adjust size as needed
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20) // Add padding around the image
                                    .padding(.vertical, 20)
                                    .background(Color(hex: "FD5F00"))
                            
                        }
                        .cornerRadius(50)
                        //.padding(.bottom, 30) // Adjust bottom padding
                        .padding(.top, 390) // Adjust top padding
                        .shadow(radius: 10)
                    }
                    Spacer()
                    // Add Spacer to push content to top
                }
            )
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
            Image("loginBg") // Add your image name here
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("LibriLand")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 80) // Adjust top padding
                
                Text(primaryText)
                    .font(.custom("SF Pro Display", size: 20).bold())
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40) // Adjust top padding
                
                Text(secondaryText)
                    .font(.title3)
                    .foregroundColor(.black.opacity(0.5))
                    .padding(.top,30)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(hex: "F6E8EA"))
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
}



struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
