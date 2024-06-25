
//
//  PasswordDetailView.swift
//  PasswordManager
//
//  Created by Saurabh Mishra on 25/06/24.
//

import SwiftUI

struct PasswordDetailView: View {
    var password: Password
    @EnvironmentObject var passwordStore: PasswordStore
    @Environment(\.presentationMode) var presentationMode
    @State private var accountType: String
    @State private var username: String
    @State private var passwordText: String
    
    
    init(password: Password) {
        self.password = password
        _accountType = State(initialValue: password.accountType)
        _username = State(initialValue: password.username)
        _passwordText = State(initialValue: password.password)
    }
    
    var body: some View {
        Form {
            TextField("Account Type", text: $accountType)
            TextField("Username/Email", text: $username)
            SecureField("Password", text: $passwordText)
            
            Button(action: {
                passwordStore.editPassword(id: password.id, accountType: accountType, username: username, password: passwordText)
                presentationMode.wrappedValue.dismiss()
                
            }) {
                Text("Edit")
            }
            .foregroundColor(.blue)

            Button(action: {
                passwordStore.deletePassword(id: password.id)
            }) {
                Text("Delete")
            }
            .foregroundColor(.red)
        }
        .navigationBarTitle("Account Details")
    }
}


