import SwiftUI
import FirebaseAuth

struct Tab_Bar: View {
   // @State private var isLoggedIn = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userID") private var userID: String = ""
    @State private var selection = 1
    @State private var showSignInView = false

 
    
    var body: some View {
       // NavigationView{
            
            ZStack {
                //Color.black.ignoresSafeArea()
                VStack(spacing:0) {
                    HStack(spacing: 0) {
                        
                        Text("LMS")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.green)
                            .padding(.leading,4)
                        
                        Text("10")
                            .foregroundStyle(Color.primary)
                            .font(.title3)
                            .bold()
                        
                        Spacer()
                        HStack{
                            
                            NavigationLink{
                                NotificationView()
                            }label: {
                                Image(systemName: "bell")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .padding(.trailing,20)
                            }
                            
                            NavigationLink{
                                SettingsView(showSignInView: $showSignInView)
                            }label: {
                                Image(systemName: "gearshape")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .padding(.trailing,20)
                            }
                           
                            
                        }
                    }.padding(.horizontal)
                    
                    
                    
                    if isLoggedIn {
                        TabView(selection: $selection) {
                            UserDashboardView_New()
                                .tabItem {
                                    Label("Home", systemImage: "house")
                                }.tag(1)
                            
//                            Content1View()
//                                .tabItem {
//                                    Label("Scan", systemImage: "barcode.viewfinder")
//                                }.tag(5)
                            
                            
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
                        .accentColor(.primary) // Set the color of the selected tab
                        .background(Color.secondary)
                        .foregroundColor(.white)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        //.preferredColorScheme(.dark)
                        .edgesIgnoringSafeArea(.all) // Ignore safe area to cover the entire screen
                        
                    } else {
                        // If user is not logged in, show the login view
                        LoginView()
                    }
                    
                }
                //.padding(.top,-25)
            }.navigationBarBackButtonHidden(true)
            .onAppear {
                // Check user authentication state when the view appears
                isLoggedIn = Auth.auth().currentUser != nil
            }
      //  }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        Tab_Bar()
    }
}
