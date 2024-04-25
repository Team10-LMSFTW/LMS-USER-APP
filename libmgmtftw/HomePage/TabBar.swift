import SwiftUI

struct TabBar: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 35) { // Adjust spacing between buttons
                    // Home Button
                    Button(action: {
                        // Action for home button
                    }) {
                        Image(systemName: "house")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                    
                    // Dollar Button
                    Button(action: {
                        // Action for dollar button
                    }) {
                        Image("rupee")
                            .resizable()
                            .frame(width: 33, height: 33)
                    }
                    
                    Spacer()
                    

                    Button(action: {

                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                    
             
                    Button(action: {
                   
                    }) {
                        Image(systemName: "person")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding(.vertical, 14)
            .frame(width: 390, height: 100, alignment: .topLeading)
            .background(Color(red: 0.36, green: 0.27, blue: 0.48))
            .cornerRadius(35)
            .shadow(color: Color(red: 0.16, green: 0.15, blue: 0.51).opacity(1), radius: 15, x: 0, y: -5)
            
            // Add Button
            Button(action: {

            }) {
                Image("addButton")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .offset(x: 0, y: -50)
            }
        }
    }
}

#Preview {
    TabBar()
}
