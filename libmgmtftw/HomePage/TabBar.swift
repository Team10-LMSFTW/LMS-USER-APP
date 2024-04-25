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

//import SwiftUI
//
//struct TabBar: View {
//    @State private var selectedTab = 0 // Track selected tab index
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//                       
//            Color.purple
//                .ignoresSafeArea()
//                .overlay(
//                    RadialGradient(gradient: Gradient(colors: [Color(red: 18/255, green: 0/255, blue: 91/255), Color(red: 116/255, green: 2/255, blue: 158/255)]), center: .center, startRadius: 5, endRadius: 500)
//                        .edgesIgnoringSafeArea(.all)
//                )
//
//            TabView(selection: $selectedTab) {
//                // First Tab
//                VStack {
//
//                        
//                        VStack(spacing: 0) {
//                            Spacer()
//                            
//                            Text("Tab Bar Content")
//                                .foregroundColor(.white)
//                            
//                            Spacer()
//                            
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 20)
//                                    .foregroundColor(Color(red: 18/255, green: 0/255, blue: 91/255)) // Darker color
//                                    .edgesIgnoringSafeArea(.bottom)
//                                    .frame(height: 80)
//                                HStack {
//                                    TabBarItem(imageName: "house", text: "Home", tag: 0).tag(0)
//                                    Spacer()
//                                    TabBarItem(imageName: "paperplane", text: "Messages", tag: 1).tag(1)
//                                    Spacer()
//                                    HexagonAddButton(destination: AnyView(AddView()), tag: 2)
//                                        .frame(width: 60, height: 60) // Adjust size as needed
//                                    Spacer()
//                                    TabBarItem(imageName: "magnifyingglass", text: "Search", tag: 3)
//                                    Spacer()
//                                    TabBarItem(imageName: "person", text: "Profile", tag: 4)
//                                }
//                                .padding(.horizontal, 20)
//                                .padding(.bottom, 15)
//                                .foregroundColor(.white)
//                            }
//                     
//                    }
//                }
//                .tag(0) // Tag for the first tab
//                
//                // Add other tabs here with different content
//                Text("Second Tab Content")
//                    .tag(1)
//                
//                Text("Third Tab Content")
//                    .tag(2)
//                
//                Text("Fourth Tab Content")
//                    .tag(3)
//                
//                Text("Fifth Tab Content")
//                    .tag(4)
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide the default index display
//            
//            // Other pages displayed over the tab bar
//          
//            // Add other pages as needed
//        }
//        .onAppear {
//            UITabBar.appearance().isHidden = true // Hide the default tab bar
//        }
//    }
//}
//
//struct TabBarItem: View {
//    var imageName: String
//    var text: String
//    var tag: Int // Tag value for the tab bar item
//    @State private var selectedTab = 0
//    var body: some View {
//        Button(action: {
//            selectedTab = tag
//            
//            switch tag {
//                        case 0:
//                            print("First tab selected")
//                        case 1:
//                            print("Second tab selected")
//                        case 2:
//                            print("Third tab selected")
//                        case 3:
//                            print("Fourth tab selected")
//                        case 4:
//                            print("Fifth tab selected")
//                        default:
//                            break
//                        }// Set selected tab to the tag value
//        }) {
//            VStack(spacing: 5) {
//                Image(systemName: imageName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 25, height: 25)
//                
//               
//            }
//        }
//        
//    }
//}
//
//struct HexagonAddButton: View {
//    var destination: AnyView // Destination view for the add button
//    var tag: Int // Tag value for the add button
//    
//    var body: some View {
//        @State  var selectedTab = 0
//        Button(action: {
//            selectedTab = tag // Set selected tab to the tag value
//        }) {
//            Hexagon()
//                .fill(Color.white)
//                .overlay(
//                    Image(systemName: "plus")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .foregroundColor(.blue)
//                        .frame(width: 30, height: 30)
//                )
//        }
//    }
//}
//
//struct Hexagon: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        
//        let width = rect.size.width
//        let height = rect.size.height
//        
//        path.move(to: CGPoint(x: width * 0.5, y: 0))
//        path.addLine(to: CGPoint(x: width, y: height * 0.25))
//        path.addLine(to: CGPoint(x: width, y: height * 0.75))
//        path.addLine(to: CGPoint(x: width * 0.5, y: height))
//        path.addLine(to: CGPoint(x: 0, y: height * 0.75))
//        path.addLine(to: CGPoint(x: 0, y: height * 0.25))
//        path.closeSubpath()
//        
//        return path
//    }
//}
//
//// Example views for demonstration
//struct OtherPage1: View {
//    var body: some View {
//        Text("Other Page 1")
//    }
//}
//
//struct OtherPage2: View {
//    var body: some View {
//        Text("Other Page 2")
//    }
//}
//
//struct AddView: View {
//    var body: some View {
//        Text("Add View")
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar()
//    }
//}

