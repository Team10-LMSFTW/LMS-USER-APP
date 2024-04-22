//
//  SignInView.swift
//  libmgmtftw
//
//  Created by Anvit Pawar on 22/04/24.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @State var email = ""
    @State var password = ""
    @State var showAlert = false
    @State var alertMessage = ""
    @State var successMessage = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: { login() }) {
                Text("Sign in")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: { signUp() }) {
                Text("Sign up")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: { resetPassword() }) {
                Text("Forgot Password?")
                    .foregroundColor(.blue)
            }
            .padding()
            
            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                print("Login error: \(error.localizedDescription)")
            } else {
                successMessage = "Signed in successfully!"
                print("Login successful")
            }
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                print("Sign up error: \(error.localizedDescription)")
            } else {
                successMessage = "Signed up successfully!"
                print("Sign up successful")
            }
        }
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                print("Reset password error: \(error.localizedDescription)")
            } else {
                successMessage = "Password reset email sent. Please check your inbox."
                print("Password reset email sent")
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
