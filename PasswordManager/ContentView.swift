//
//  ContentView.swift
//  PasswordManager
//
//  Created by Saurabh Mishra on 25/06/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var passwordStore: PasswordStore
    @State private var isPresentingAddPasswordView = false
    @State private var isPresentingDetailView = false
    @State private var selectedPassword: Password?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(passwordStore.passwords) { password in
                        Button(action: {
                            selectedPassword = password
                            isPresentingDetailView = true
                        }) {
                            HStack {
                                Text(password.accountType)
                                Spacer()
                                Text("******") // Show masked password
                            }
                        }
                    }
                    .onDelete(perform: deletePassword)
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isPresentingAddPasswordView = true
                    }) {
                        Image("AddImg")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding()
                    }
                }
            }
            .navigationBarTitle("Password Manager")
        }
        .bottomSheet(isPresented: $isPresentingAddPasswordView) {
            AddPasswordView(isPresented: $isPresentingAddPasswordView)
                .environmentObject(passwordStore)
        }
        .bottomSheet(isPresented: $isPresentingDetailView) {
            if let selectedPassword = selectedPassword {
                PasswordDetailView(password: selectedPassword)
                    .environmentObject(passwordStore)
            }
        }
    }

    func deletePassword(at offsets: IndexSet) {
        offsets.forEach { index in
            let password = passwordStore.passwords[index]
            passwordStore.deletePassword(id: password.id)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PasswordStore())
}
