import SwiftUI

struct HistoryPage: View {
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color(hex: "#14110F"), Color(red: 0.13, green: 0.07, blue: 0.1)]), center: .center, startRadius: 1, endRadius: 400)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("History")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                    
                    Spacer().frame(height: 10)
                    
                    HistoryRow(bookName: "Harry Potter", status: .borrowed, date: "28 Apr 2024", imageName: "image1")
                    HistoryRow(bookName: "The Kite Runner", status: .returnedOnTime, date: "29 Apr 2024", imageName: "Onboarding3")
                    HistoryRow(bookName: "The Subtle Art Of Not Giving A Fuck", status: .due, date: "30 Apr 2024", imageName: "image1")
                    HistoryRow(bookName: "Jawaan", status: .borrowed, date: "1 May 2024", imageName: "Onboarding3")
                    
                    Spacer()
                }
                .padding(20)
            }
        }
    }
}

struct HistoryRow: View {
    var bookName: String
    var status: BookStatus
    var date: String
    var imageName: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .padding(.leading, 5) // Adjusted leading padding
            
            VStack(alignment: .leading, spacing: 5) {
                Text(bookName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(status.rawValue)
                    .font(.subheadline)
                    .foregroundColor(status.color)
                
            }
            .padding(.leading, 10)
            
            Spacer()
            
            Text(date)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.trailing, 10)
                .padding(.bottom, 5)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.5))
        .cornerRadius(10)
    }
}

enum BookStatus: String {
    case borrowed = "Borrowed"
    case returnedOnTime = "Returned"
    case due = "Due"
    
    var color: Color {
        switch self {
        case .borrowed:
            return .yellow
        case .returnedOnTime:
            return .green
        case .due:
            return .red
        }
    }
}

struct HistoryPage_Previews: PreviewProvider {
    static var previews: some View {
        HistoryPage()
    }
}
