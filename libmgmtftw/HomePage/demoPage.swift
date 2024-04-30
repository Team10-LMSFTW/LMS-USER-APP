import SwiftUI
import FirebaseAuth

struct demoPage: View {
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var userEmail: String = ""

    var body: some View {
        if isLoggedIn {
            NavigationStack {
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                        .ignoresSafeArea()
                    VStack {
                        Text("Welcome to Demo Page")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                        Text("Logged in as: \(userEmail)")
                            .foregroundColor(.white)
                            .padding()
                        Button(action: logout) {
                            Text("Logout")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    fetchUserEmail()
                }
            }.navigationBarBackButtonHidden(true)
        } else {
            NavigationLink(destination: LoginView(), isActive: $isLoggedIn) {
                EmptyView()
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            isLoggedIn = false
            print("Logged OUT")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func fetchUserEmail() {
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email ?? "Unknown"
            if let atIndex = userEmail.firstIndex(of: "@") {
                userEmail = String(userEmail[..<atIndex])
            }
        }
    }
}

struct demoPage_Previews: PreviewProvider {
    static var previews: some View {
        demoPage()
    }
}
