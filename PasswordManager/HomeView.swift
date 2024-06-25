//
//  HomeView.swift
//  PasswordManager
//
//  Created by Saurabh Mishra on 25/06/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var passwordStore: PasswordStore
    @State private var isPresentingAddPasswordView = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(passwordStore.passwords) { password in
                        NavigationLink(destination: PasswordDetailView(password: password)) {
                            HStack {
                                Text(password.accountType)
                                Spacer()
                                Text("******")
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
                        Image(systemName: "plus.circle.fill")
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
    }

    func deletePassword(at offsets: IndexSet) {
        offsets.forEach { index in
            let password = passwordStore.passwords[index]
            passwordStore.deletePassword(id: password.id)
        }
    }
}

#Preview {
    HomeView()
}

