//
//  EncryptionHelper.swift
//  PasswordManager
//
//  Created by Saurabh Mishra on 25/06/24.
//

import Foundation
import CommonCrypto

class EncryptionHelper {
    static let key = generateKey(from: "Saurabh")

    static func generateKey(from string: String) -> String {
        let repeatedString = String(repeating: string, count: (32 / string.count) + 1)
        return String(repeatedString.prefix(32))
    }

    static func encrypt(_ string: String) throws -> String {
        let data = string.data(using: .utf8)!
        let encryptedData = try crypt(data: data, option: CCOperation(kCCEncrypt))
        return encryptedData.base64EncodedString()
    }

    static func decrypt(_ base64String: String) throws -> String {
        guard let data = Data(base64Encoded: base64String) else {
            throw NSError(domain: "Invalid base64 string", code: -1, userInfo: nil)
        }
        let decryptedData = try crypt(data: data, option: CCOperation(kCCDecrypt))
        return String(data: decryptedData, encoding: .utf8) ?? ""
    }

    private static func crypt(data: Data, option: CCOperation) throws -> Data {
        let keyData = key.data(using: .utf8)!
        let truncatedKeyData = keyData.prefix(kCCKeySizeAES256)

        let ivSize = kCCBlockSizeAES128
        let cryptLength = size_t(ivSize + data.count + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)

        let keyLength = size_t(kCCKeySizeAES256)
        let options = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                truncatedKeyData.withUnsafeBytes { keyBytes in
                    CCCrypt(option, CCAlgorithm(kCCAlgorithmAES128), options,
                            keyBytes.baseAddress, keyLength, nil,
                            dataBytes.baseAddress, data.count,
                            cryptBytes.baseAddress! + ivSize, cryptLength,
                            &bytesLength)
                }
            }
        }

        guard cryptStatus == kCCSuccess else {
            throw NSError(domain: "Error in encryption", code: Int(cryptStatus), userInfo: nil)
        }

        cryptData.count = bytesLength + ivSize
        return cryptData
    }
}
