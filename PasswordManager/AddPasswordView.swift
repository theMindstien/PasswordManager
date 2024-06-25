//
//  AddPasswordView.swift
//  PasswordManager
//
//  Created by Saurabh Mishra on 25/06/24.
//

import SwiftUI

struct AddPasswordView: View {
    @EnvironmentObject var passwordStore: PasswordStore
    @Binding var isPresented: Bool
    @State private var accountType = ""
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            Form {
                TextField("Account Type", text: $accountType)
                TextField("Username/Email", text: $username)
                SecureField("Password", text: $password)
            }
            .padding(.bottom, 20)
            
            Button(action: {
                if accountType.isEmpty || username.isEmpty || password.isEmpty {
                    alertMessage = "Please fill in all fields to proceed."
                    showAlert = true
                } else {
                    passwordStore.addPassword(accountType: accountType, username: username, password: password)
                    isPresented = false // Dismiss the view after adding the password
                }
            }) {
                Text("Add New Account")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitle("Add New Account", displayMode: .inline)
    }
}
