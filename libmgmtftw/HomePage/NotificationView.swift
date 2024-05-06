import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack {
            List {
                Section(header: Text("Today")) {
                    let items = [("Book Due", "Your Book is Due"), ("Due Date Nearing", "The Alchemist is nearing its due date"), ("Collect Now", "Harry Potter is ready for pick-up!")]
                    ForEach(items, id: \.0) { item, subheadline in
                        NavigationLink(destination: DetailView(headline: item, subheadline: subheadline)) {
                            NotificationItemView(headline: item, subheadline: subheadline)
                        }
                    }
                }
                
                Section(header: Text("Yesterday")) {
                    
                    // Add notifications for yesterday here if any
                }
                
                // Add more sections for previous dates if needed
            }
            .listStyle(InsetGroupedListStyle()) // Add list style for better appearance
            .navigationTitle("Notifications")
        }
        .background(Color.white.ignoresSafeArea())
    }
}

struct NotificationItemView: View {
    var headline: String
    var subheadline: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "newspaper.circle") // System image for news
                .foregroundColor(.primary)
                .font(.largeTitle)
                .padding(.leading, -20)
                
            VStack(alignment: .leading, spacing: 4) {
                Text(headline)
                    .font(.headline)
                Text(subheadline)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button(action: {
                // Action to disable notification
                print("Notification Disabled")
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
