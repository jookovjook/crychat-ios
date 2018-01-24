//
//  CryGraphy.swift
//  crychat
//
//  Created by Жека on 23/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation

class CryParams {
    
    static let applicationTag : String = "com.jookovjook.crychat"
    static let keySizeInBits : Int = 512
    static let keyType : CFString = kSecAttrKeyTypeRSA
    static let bufferSize : Int = Int(floor(Double(keySizeInBits/8))) - 11
    static let l : Int = 88 //length of a part of encrypted string in format base64. This value is different for different key sizes and key types
    
    static let privateKeyParams: [String: AnyObject] = [
        kSecAttrIsPermanent as String: true as AnyObject,
        kSecAttrApplicationTag as String: applicationTag as AnyObject
    ]
    
    static let publicKeyParams: [String: AnyObject] = [
        kSecAttrIsPermanent as String: true as AnyObject,
        kSecAttrApplicationTag as String: applicationTag as AnyObject
    ]

    static let parameters: [String: AnyObject] = [
        kSecAttrKeyType as String:          keyType,
        kSecAttrKeySizeInBits as String:    keySizeInBits as AnyObject,
        kSecPublicKeyAttrs as String:       publicKeyParams as AnyObject,
        kSecPrivateKeyAttrs as String:      privateKeyParams as AnyObject,
        ]
    
}

enum CryKey{
    case publ
    case priv
}

func generateKeyPair() -> (String, String){
    var pubKey, privKey: SecKey?
    var publicKey : String = ""
    var privateKey: String = ""
    var error:Unmanaged<CFError>?
    
    SecKeyGeneratePair(CryParams.parameters as CFDictionary, &pubKey, &privKey)
    
    if let cfdata = SecKeyCopyExternalRepresentation(pubKey!, &error) {
        let data:Data = cfdata as Data
        publicKey = data.base64EncodedString()
        print("Base64 encoded key:\(publicKey)")
//        print()
        let hexString = data.hexEncodedString()
        print("Hex public key: \(hexString)")
        let data2 = hexString.hexadecimal()
        print("Base64 reencoded key:\(data2?.base64EncodedString())")
//        le
        
    }
    
    if let cfdata = SecKeyCopyExternalRepresentation(privKey!, &error) {
        let data:Data = cfdata as Data
        print("Hex private key: \(data.hexEncodedString())")
        privateKey = data.base64EncodedString()
    }
    
    return (publicKey, privateKey)
}

func splitString(_ string: String) -> [String] {
    let splitSize = CryParams.l
    let cnt = string.count / splitSize
    var stringsArray : [String] = []
    for i in (0...(cnt-1)){
        stringsArray.append(string.subString(startIndex: i*splitSize, endIndex: (i+1)*splitSize - 1))
    }
    return stringsArray
}

func stringToDataArray(_ string: String) -> [Data] {
    let patchSymbol : UInt8 = 32
    let bufferSize = CryParams.bufferSize
    
    var data = string.data(using: .utf8)!
    
    var appendCount = bufferSize - data.count % bufferSize
    if(appendCount == bufferSize && data.count > 0) { appendCount = 0 }
    
    data.append(Data(repeating: patchSymbol, count: appendCount))
    var splittedData : [Data] = []
    for i in 0...(data.count / bufferSize - 1){
        splittedData.append(data[(i*bufferSize)..<((i+1)*bufferSize)])
    }
    
    return splittedData
}

func pubKey(from b64Key: String) -> SecKey? {
    return secKey(from: b64Key, type: CryKey.publ)
}

func privKey(from b64Key: String) -> SecKey? {
    return secKey(from: b64Key, type: CryKey.priv)
}

func secKey(from b64Key: String, type : CryKey) -> SecKey? {
    
    guard let data = Data.init(base64Encoded: b64Key) else {
        return nil
    }
    
    let keyDict:[NSObject:NSObject] = [
        kSecAttrKeyType: CryParams.keyType,
        kSecAttrKeyClass: type == CryKey.publ ? kSecAttrKeyClassPublic : kSecAttrKeyClassPrivate,
        kSecAttrKeySizeInBits: NSNumber(value: CryParams.keySizeInBits),
        kSecReturnPersistentRef: true as NSObject
    ]
    
    if let publicKey = SecKeyCreateWithData(data as CFData, keyDict as CFDictionary, nil){
        return publicKey
    }else{
        return nil
    }
}

func encryptString(_ string: String, with key: SecKey) -> String {
    let datArray = stringToDataArray(string)
    var encryptedString = ""
    for data in datArray {
        let encryptedData = encryptData(data, with: key)
        let base64String = encryptedData.base64EncodedString()
        encryptedString = encryptedString + base64String
    }
    return encryptedString
}

func encryptData(_ data: Data, with key: SecKey) -> Data {
    let plainText = (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count)
    let plainTextLen = data.count
    
    var cipherData = Data(count: SecKeyGetBlockSize(key))
    let cipherText = cipherData.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
        return bytes
    })
    var cipherTextLen = cipherData.count
    
    SecKeyEncrypt(key, .PKCS1, plainText, plainTextLen, cipherText, &cipherTextLen)
    
    return cipherData
}

//func encrypt(_ message: String, with key: SecKey) -> String?{
//
////    let message = "message"
//
//    guard let messageData = message.data(using: .utf8) else {
//        return nil
//    }
//    let plainText = (messageData as NSData).bytes.bindMemory(to: UInt8.self, capacity: messageData.count)
//    let plainTextLen = messageData.count
//
//    // prepare output data buffer
//    var cipherData = Data(count: SecKeyGetBlockSize(key))
//    let cipherText = cipherData.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
//        return bytes
//    })
//    var cipherTextLen = cipherData.count
//
//    SecKeyEncrypt(key, .PKCS1, plainText, plainTextLen, cipherText, &cipherTextLen)
//
//    return cipherData.base64EncodedString()
//}

func decryptString(_ encryptedString: String, with key: SecKey) -> String {
    let stringsArray = splitString(encryptedString)
    var decryptedString = ""
    
    for string in stringsArray {
        if let decryptedPart = decrypt(string, with: key) {
            decryptedString = decryptedString + decryptedPart
        }else{
            decryptedString = decryptedString + "*error*"
        }
        
    }
    
    return decryptedString
}

func decrypt(_ message: String, with key: SecKey) -> String? {
    
    let encryptedData = Data(base64Encoded: message, options: [])
    let encryptedText = (encryptedData! as NSData).bytes.bindMemory(to: UInt8.self, capacity: (encryptedData?.count)!)
    let encryptedTextLen = encryptedData?.count
    
    var plainData = Data(count: CryParams.bufferSize)
    let plainText = plainData.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
        return bytes
    })
    var plainTextLen = plainData.count
    
    SecKeyDecrypt(key, .PKCS1, encryptedText, encryptedTextLen!, plainText, &plainTextLen)
    
    let string = NSString(data: plainData as Data, encoding: String.Encoding.utf8.rawValue) as String?
    
    return string
    
}
