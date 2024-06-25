//
//  Password.swift
//  PasswordManager
//
//  Created by Saurabh Mishra on 25/06/24.
//

import Foundation

struct Password: Identifiable {
    var id = UUID()
    var accountType: String
    var username: String
    var password: String
}
