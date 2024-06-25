//
//  PasswordManagerApp.swift
//  PasswordManager
//
//  Created by Saurabh Mishra on 25/06/24.
//

import SwiftUI

@main
struct PasswordManagerApp: App {
    @StateObject private var passwordStore = PasswordStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(passwordStore)
                .onAppear {
                    passwordStore.loadPasswords()
                }
        }
    }
}




