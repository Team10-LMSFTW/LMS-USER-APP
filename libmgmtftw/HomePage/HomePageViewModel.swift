//
//  HomePageViewModel.swift
//  libmgmtftw
//
//  Created by Anvit Pawar on 06/05/24.
//

import SwiftUI
import FirebaseAuth

struct HomePageView1: View {
    @State private var userEmail: String = ""
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    func dayOfWeek(date: Date) -> String {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
            
            // Function to get the month of the year
            func monthOfYear(date: Date) -> String {
                dateFormatter.dateFormat = "MMMM"
                return dateFormatter.string(from: date)
            }
            
            // Function to get the day of the month
            func dayOfMonth(date: Date) -> String {
                dateFormatter.dateFormat = "d"
                return dateFormatter.string(from: date)
            }
    var body: some View {
        HStack {
            Text("\(dayOfWeek(date: currentDate)), ")
                .font(.title3)
                .padding(.leading,20)
                //.textCase(.uppercase)
            //.bold()
            
            Text(monthOfYear(date: currentDate))
                .font(.title3)
                .padding(.leading,-10)
               // .textCase(.uppercase)
            // .bold()
            
            Text(dayOfMonth(date: currentDate))
                .font(.title3)
                .padding(.leading,-6)
                //.textCase(.uppercase)
            //.bold()
            
            Spacer()
        }.foregroundColor(.gray)
        
        
        
        // Greetings and user information
        HStack {
            Text("Hi, \(userEmail.uppercased())")
                .font(.largeTitle)
                .foregroundColor(.primary)
                .padding(.leading, 20)
                //.padding(.bottom,20)
            
            Spacer()
        }
        .padding(.bottom, 15)
        
        .onAppear {
            fetchUserEmail()
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

#Preview {
    HomePageView1()
}
