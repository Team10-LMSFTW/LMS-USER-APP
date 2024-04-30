import SwiftUI
import FirebaseAuth

struct Tab_Bar: View {
   // @State private var isLoggedIn = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userID") private var userID: String = ""
    @State private var selection = 3

    
    init() {
        UITabBar.appearance().barTintColor = UIColor.black // Set the background color of the tab bar
        UITabBar.appearance().shadowImage = UIImage() // Remove the default shadow
        UITabBar.appearance().backgroundImage = UIImage() // Remove the default background image
        UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: 10) // Add a shadow
        UITabBar.appearance().layer.shadowRadius = 8 // Adjust the shadow radius
        UITabBar.appearance().layer.shadowColor = UIColor.black.cgColor // Shadow color
        UITabBar.appearance().layer.shadowOpacity = 1 // Shadow opacity
    }
    
    var body: some View {
        VStack {
            if isLoggedIn {
                TabView(selection:$selection) {
                    demoPage()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }.tag(1)
                    
                    HistoryPage()
                        .tabItem {
                            Label("History", systemImage: "clock")
                        }.tag(2)
                    
                    ExplorePageView(userID: "", username: "")
                        .tabItem {
                            Label("Explore", systemImage: "magnifyingglass")
                        }.tag(3)
                    
                    demoPage()
                        .tabItem {
                            Label("Add", systemImage: "plus")
                        }.tag(4)
                }
                .accentColor(.white) // Set the color of the selected tab
                .foregroundColor(.white)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            } else {
                // If user is not logged in, show the login view
                LoginView()
            }
        }
        .onAppear {
            // Check user authentication state when the view appears
            isLoggedIn = Auth.auth().currentUser != nil
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        Tab_Bar()
    }
}
