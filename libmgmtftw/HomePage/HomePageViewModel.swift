import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomePageView1: View {
    @State private var userName: String = ""
    @State private var showSignInView = false
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
        HStack(spacing: 0) {
        VStack (alignment:.leading,spacing: 5) {
            Text("\(dayOfWeek(date: currentDate)), \(monthOfYear(date: currentDate)) \(dayOfMonth(date: currentDate))")
                .font(.subheadline)
            
                .foregroundColor(.gray)
            
            Text("Hey, ")
                .font(.title)
                .foregroundColor(.primary)
            +
            Text("\(userName)!")
                .font(.title)
                .bold()
                .foregroundColor(.primary)

        }
       
            
            Spacer()
            HStack{
                NavigationLink(destination: NotificationView()) {
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.trailing,20)
                }
                
                NavigationLink(destination: SettingsView(showSignInView: $showSignInView)) {
                    Image("male")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
        }.padding()
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
