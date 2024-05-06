import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        NavigationView {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                    .ignoresSafeArea()
                
                List {
                    Button("Log Out") {
                        Task {
                            do {
                                try viewModel.logout()
                                showSignInView = true
                                print(showSignInView)
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    }
                }
                .listRowBackground(Color.green) // Set list row background color to clear
                
                .navigationTitle("Settings")
            }
            .background(Color(hex: "#14110F").ignoresSafeArea()) // Set background color for entire ZStack
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle to ensure consistent navigation behavior
       // .preferredColorScheme(.dark) // Set preferred color scheme to dark mode
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}
