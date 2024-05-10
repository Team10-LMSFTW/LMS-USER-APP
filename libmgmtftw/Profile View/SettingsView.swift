import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var totalPendingPenalty: Int = 0
    @State private var membership_type: String = ""
    @State private var isMembershipDetailsActive = false // New state to control navigation
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                    .ignoresSafeArea()
                
                List {
                    
                    NavigationLink("Membership", destination: CommonDetailView(detailType: .membership(membership_type)))
                    
                    
                    NavigationLink("Pay Dues", destination: CommonDetailView(detailType: .penalty("\(totalPendingPenalty)")))
                    
                    Button("Log Out") {
                                           Task {
                                               do {
                                                   try await viewModel.logout()
                                                   showSignInView = true
                                                   print(showSignInView)
                                               } catch {
                                                   print("Error: \(error)")
                                               }
                                           }
                                       }.foregroundColor(.red)
                    
                }.navigationViewStyle(.stack)
                
                
                
                
                .listRowBackground(Color.clear) // Set list row background color to clear
                
            }.navigationTitle("Profile")
            }
            .background(Color(hex: "#14110F").ignoresSafeArea()) // Set background color for entire ZStack
        }
         // Use StackNavigationViewStyle to ensure consistent navigation behavior
    }


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}
