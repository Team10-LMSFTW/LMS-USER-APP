import SwiftUI

struct NotificationView: View {
    @State private var notifications = [
        Notification(headline: "Book Due Passed !", subheadline: "Harry Potter and the Philosophers Stone is due, return today!"),
        Notification(headline: "Due Date is Nearing", subheadline: "It ends with us is nearing its due date"),
        Notification(headline: "Ready to pick", subheadline: "The Alchemist is ready for pick-up from the library!")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Latest Notifications")) {
                        ForEach(notifications) { notification in
                            NotificationItemView(notification: notification)
                        }
                        .onDelete(perform: deleteNotification)
                    }
                }
                .listStyle(InsetGroupedListStyle()) // Add list style for better appearance
                .navigationTitle("Notifications")
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
    
    private func deleteNotification(at offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
    }
}

struct NotificationItemView: View {
    var notification: Notification
    
    var body: some View {
        HStack(spacing: 2) {
            if notification.headline == "Book Due Passed !" {
                Image(systemName: "exclamationmark.octagon") // System image for news
                    .foregroundColor(.red)
                    .font(.title3)
                    .padding()
                    .padding(.leading, -20)
            } else {
                Image(systemName: "newspaper.circle") // System image for news
                    .foregroundColor(.primary)
                    .padding()
                    .font(.title3)
                    .padding(.leading, -20)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if notification.headline == "Book Due Passed !" {
                    Text(notification.headline)
                        .font(.title3)
                        .foregroundColor(.red)
                } else {
                    Text(notification.headline)
                        .font(.title3)
                }
                Text(notification.subheadline)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
//            Button(action: {
//                // Action to disable notification
//                print("Notification Disabled")
//            }) {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.title3)
//                    .foregroundColor(.red)
//            }
        }
        .padding()
    }
}

struct Notification: Identifiable {
    let id = UUID()
    let headline: String
    let subheadline: String
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
