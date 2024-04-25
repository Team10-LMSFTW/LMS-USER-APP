import SwiftUI

struct BookDetailsView: View {
    @State private var isFavorite = false
    
    var body: some View {
        ZStack {
            Color(hex: "FAF9F6")
                .ignoresSafeArea()
            
           
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Spacer()
                            Button(action: {
                                isFavorite.toggle()
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(isFavorite ? .red : .black)
                            }
                            .padding()
                            
                            Button(action: {
                                
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.black)
                            }
                            
                        }
                        BookHeaderView()
                        BookDetailInfoView()
                        Spacer()
                        ActionButtonsView()
                    }
                    .padding()
                }
                .navigationBarTitle("Book Details", displayMode: .inline)
            }
        
        .overlay(
            TabBar()
                .position(x:200, y:760)
        )
    }
}

struct BookHeaderView: View {
    var body: some View {
        HStack(spacing: 15) {
            Image("grad2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("To Kill a Mockingbird")
                    .font(.title)
                    .fontWeight(.bold)
                
                StarRatingView(rating: 4.5)
                
                Text("(120 ratings)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("Genre: Children, Horror, Thriller")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Available")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.top, 5)
            }
            Spacer()
        }
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct BookDetailInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About Book")
                .font(.headline)
            Divider()
            Text("Author: J.K. Rowling Howling")
            Text("Overview:")
                .font(.subheadline)
                .fontWeight(.bold)
            Text("The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it. The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it.")
        }
    }
}

struct ActionButtonsView: View {
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {}) {
                Text("Add to WishList")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Button(action: {}) {
                Text("Borrow now")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
    }
}

struct StarRatingView: View {
    var rating: Double
    
    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                if Double(index) <= rating {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else if Double(index - 1) < rating {
                    Image(systemName: "star.lefthalf.fill")
                        .foregroundColor(.yellow)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct BookDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailsView()
    }
}
