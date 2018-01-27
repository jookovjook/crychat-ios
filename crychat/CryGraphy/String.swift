//
//  String.swift
//  crychat
//
//  Created by Жека on 25/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation
import CryptoSwift

extension String {
 
    func encrypt(with key: SecKey) -> String {
        let cleanData = self.data(using: .utf8)!
        let encryptedData = cleanData.encrypt(with: key)
        return encryptedData.base64EncodedString()
    }
    
    func decrypt(with key: SecKey) -> String {
        let encryptedData = Data(base64Encoded: self, options: [])!
        let decryptedData = encryptedData.decrypt(with: key)
        return String(data: decryptedData, encoding: .utf8) ?? "*error*"
    }
    
    func aesEncrypt(with key: String) -> String {
        do {
            let aes = try AES(key: key)
            let ciphertext = try aes.encrypt(Array(self.utf8))
            return Data(bytes: ciphertext).base64EncodedString()
        }catch{
            return "*aes_error*"
        }
    }
    
    func aesDecrypt(with key: String) -> String {
        do {
            let aes = try AES(key: key)
            let decryptedTxt = try aes.decrypt(Array(Data(base64Encoded: self, options: [])!))
            return String(data: Data(bytes: decryptedTxt), encoding: .utf8) ?? "*aes_error*"
        }catch{
            return "*aes_error*"
        }
    }
    
}

func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}
