import SwiftUI
struct CarouselView: View {
    @State private var selection = 0
    
    let onboardingScreens: [(imageName: String, primaryText: String, secondaryText: String)] = [
        ("Onboarding1", "The Best Way to manage books", "Navigate Your Library World with LibriLand: Where Every Book Finds Its Place!"),
        ("Onboarding2", "Endless Adventures Await!", "Explore a World of Stories and Ideas, Where Your Imagination Knows No Bounds."),
        ("Onboarding3", "Elevate Your Experience!", "Embark on a Quest for Knowledge, Where Every Page Turn Unveils Something New.")
    ]
    
    var body: some View {
        NavigationView{
            ZStack {
                Color(hex: "767BB2").edgesIgnoringSafeArea(.all) // Set background color
                
                TabView(selection: $selection) {
                    ForEach(onboardingScreens.indices, id: \.self) { index in
                        let screen = onboardingScreens[index]
                        OnboardingScreen(imageName: screen.imageName, primaryText: screen.primaryText, secondaryText: screen.secondaryText)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .edgesIgnoringSafeArea(.all)
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
                                Text("Get Started             ")
                                    .font(Font.custom("SF Pro Display", size: 20).bold()) // Use SF Pro font with size 18 and make it bold
                                
                                    .foregroundColor(.white) // Make text color white
                                    .padding() // Add padding around the text
                                    .background(Color(hex: "767BB2"))
                                
                                
                            }
                            .cornerRadius(50)
                            //.padding(.bottom, 30) // Adjust bottom padding
                            .padding(.top, 450) // Adjust top padding
                            
                        }
                        Spacer() // Add Spacer to push content to top
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
                Color(hex: "767BB2")
                
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
                        .foregroundColor(.white)
                        .padding(.top,30)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: "5D457A"))
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
