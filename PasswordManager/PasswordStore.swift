//
//  PasswordStore.swift
//  PasswordManager
//
//  Created by Saurabh Mishra on 25/06/24.
//

import Foundation
import CoreData
import SwiftUI

class PasswordStore: ObservableObject {
    @Published var passwords: [Password] = []

    private let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "PasswordModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading CoreData: \(error)")
            }
        }
        loadPasswords()
    }

    func addPassword(accountType: String, username: String, password: String) {
        let context = container.viewContext
        let newPasswordEntity = PasswordEntity(context: context)
        newPasswordEntity.id = UUID()
        newPasswordEntity.accountType = accountType
        newPasswordEntity.username = username
        do {
            let encryptedPassword = try EncryptionHelper.encrypt(password)
            newPasswordEntity.password = encryptedPassword
            try context.save()
            loadPasswords()
        } catch {
            print("Failed to save password: \(error)")
        }
    }

    func editPassword(id: UUID, accountType: String, username: String, password: String) {
        let context = container.viewContext
        let request = NSFetchRequest<PasswordEntity>(entityName: "PasswordEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let passwordEntity = results.first {
                passwordEntity.accountType = accountType
                passwordEntity.username = username
                let encryptedPassword = try EncryptionHelper.encrypt(password)
                passwordEntity.password = encryptedPassword
                try context.save()
                loadPasswords()
            }
        } catch {
            print("Failed to edit password: \(error)")
        }
    }

    func deletePassword(id: UUID) {
        let context = container.viewContext
        let request = NSFetchRequest<PasswordEntity>(entityName: "PasswordEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let passwordEntity = results.first {
                context.delete(passwordEntity)
                try context.save()
                loadPasswords()
            }
        } catch {
            print("Failed to delete password: \(error)")
        }
    }

    func loadPasswords() {
        let context = container.viewContext
        let request = NSFetchRequest<PasswordEntity>(entityName: "PasswordEntity")

        do {
            let results = try context.fetch(request)
            passwords = results.compactMap { entity in
                guard let id = entity.id,
                      let accountType = entity.accountType,
                      let username = entity.username,
                      let encryptedPassword = entity.password else {
                    return nil
                }
                do {
                    let password = try EncryptionHelper.decrypt(encryptedPassword)
                    return Password(id: id, accountType: accountType, username: username, password: password)
                } catch {
                    print("Failed to decrypt password: \(error)")
                    return nil
                }
            }
        } catch {
            print("Failed to load passwords: \(error)")
        }
    }
}
