import SwiftUI
import FirebaseAuth

struct Tab_Bar: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userID") private var userID: String = ""
    @State private var selection = 1
    @State private var showSignInView = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
        
                
                if isLoggedIn {
                    TabView(selection: $selection) {
                        UserDashboardView_New()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }.tag(1)
                        
                        HistoryPage()
                            .tabItem {
                                Label("History", systemImage: "clock")
                            }.tag(2)
                        
                        ExplorePageView(userID: "", username: "")
                            .tabItem {
                                Label("Explore", systemImage: "books.vertical.fill")
                            }.tag(3)
                        
                        RequestsPage()
                            .tabItem {
                                Label("Request", systemImage: "doc.text.magnifyingglass")
                            }.tag(4)
                    }
                    .accentColor(.primary)
                    .background(Color.secondary)
                    .foregroundColor(.white)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .edgesIgnoringSafeArea(.all)
                } else {
                    LoginView()
                }
            }
            
            // NavigationLink to navigate to HistoryPage
//            NavigationLink(destination: HistoryPage(), tag: 2, selection: selection) {
//                EmptyView()
//            }
//            .hidden() // Hide the NavigationLink, it will be triggered programmatically
        }
        .onAppear {
            // Initially set the selection to 1 (or any other initial value)
            selection = 1
            
            // Check user authentication state when the view appears
            isLoggedIn = Auth.auth().currentUser != nil
        }
    }
}
