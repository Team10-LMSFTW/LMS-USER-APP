import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomePageView1: View {
    @State private var userName: String = ""
    let currentDate = Date()
    let dateFormatter = DateFormatter()

    func dayOfWeek(date: Date) -> String {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }

    func monthOfYear(date: Date) -> String {
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }

    func dayOfMonth(date: Date) -> String {
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }

    var body: some View {
        VStack {
            HStack {
                Text("\(dayOfWeek(date: currentDate)), ")
                    .font(.title3)
                    .padding(.leading, 20)
                Text(monthOfYear(date: currentDate))
                    .font(.title3)
                    .padding(.leading, -10)
                Text(dayOfMonth(date: currentDate))
                    .font(.title3)
                    .padding(.leading, -6)
                Spacer()
            }
            .foregroundColor(.gray)
           // .padding(.bottom, 15)

            HStack {
                Text("Hi, \(userName)")
                    .font(.title)
                    .foregroundColor(.primary)
                    .padding(.leading, 20)
                Spacer()
            }
            .padding(.bottom, 35)
        }
        .onAppear {
            fetchUserName()
        }
    }

    func fetchUserName() {
        if let currentUser = Auth.auth().currentUser {
            let db = Firestore.firestore()
            db.collection("users").document(currentUser.uid).getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }

                if let snapshot = snapshot, snapshot.exists {
                    if let firstName = snapshot.data()?["first_name"] as? String {
                        self.userName = firstName
                    } else {
                        print("First name not found in user data")
                    }
                } else {
                    print("User data not found")
                }
            }
        }
    }
}

struct HomePageView1_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView1()
    }
}
