//
//  PreLoginView.swift
//  Librin
//
//  Created by admin on 23/04/24.
//

import SwiftUI

struct PreLoginView: View {
    var body: some View {
        ZStack {
            Image("backgroundImage") // Add your image name here
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Manage Your \nShelf with \nLibriLand")
                    .font(.custom("SF Pro Display", size: 35).bold())
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .offset(x:0,y:160)
                
                Button(action: {
                    // Add your login action here
                }) {
                    Text("Login                                    ")
                        .font(Font.custom("SF Pro Display", size: 20).bold()) // Use SF Pro font with size 18 and make it bold
                        
                        .foregroundColor(.white) // Make text color white
                        .padding() // Add padding around the text
                        .background(Color(hex: "503E88"))
                        
                }
                .background(Color(hex: "503E88"))
                .cornerRadius(30)
                .offset(y:180)
                Divider()
                    .background(Color.white)
                    .frame(maxWidth: 280)
                    .offset(y:190)
                HStack {
                                    Text("Don't have an account? ")
                                        .foregroundColor(.white)
                                    
                                    Text("SignUp")
                                        .foregroundColor(.white)
                                        .underline()
                                        
                            }
                .offset(y:200)
                        }
                    }
            }
        }
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


#Preview {
    PreLoginView()
}
