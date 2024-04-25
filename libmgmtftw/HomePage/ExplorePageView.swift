import SwiftUI

struct ExplorePageView: View {
    @State private var searchText = ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(hex: "211134"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                    .ignoresSafeArea()
                
                Image("grad1")
                    .frame(width: 215, height: 215)
                    .background(Color(red: 0.05, green: 0.27, blue: 0.36))
                    .blur(radius: 100)
                
                Image("grad2")
                    .frame(width: 215, height: 215)
                    .background(Color(red: 0.26, green: 0.05, blue: 0.36))
                    .blur(radius: 100)
                
                VStack(alignment: .leading) {
                    HStack{
                        TextField(" ", text: $searchText)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .padding()
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Categories")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            CategoryScrollView()
                            
                            Text("Trending collections")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            TrendingCollectionsView()
                            
                            Text("Top seller")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            TopSellerView()
                        }
                    }
                }
            }
            .overlay(
                TabBar()
                    .position(x:200, y:760)
            )
        }
    }
}
import SwiftUI

struct CategoryScrollView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(0..<10) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 100, height: 30)
                }
            }
        }
    }
}

struct TrendingCollectionsView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(0..<3) { index in
                    VStack {
                        ImagePlaceholderView()
                        HStack {
                            Text(index == 1 ? "ART OF ART" : "Harry Potter")
                                .foregroundColor(.white)
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("20")
                                .foregroundColor(.white)
                            Spacer()

                        }
                        .padding([.horizontal, .bottom])
                    }
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(20)
                }
            }
        }
    }
}

struct TopSellerView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(0..<5) { _ in
                    VStack {
                        ImagePlaceholderView()
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.white)
                        }
                        .padding([.horizontal, .bottom])
                    }
                    .background(Color.blue.opacity(0.5))
                    .cornerRadius(20)
                }
            }
        }
    }
}

struct ImagePlaceholderView: View {
    var body: some View {
        GeometryReader { geometry in
            Image("placeholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
        .frame(height: 150)
        .onAppear {
            // Placeholder for image loading logic
        }
    }
}

//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExplorePageView()
//    }
//}
//

#Preview {
    ExplorePageView()
}
