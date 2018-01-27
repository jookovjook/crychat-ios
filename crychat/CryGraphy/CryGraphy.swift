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
    static let bufferSize : Int = Int(floor(Double(keySizeInBits/8))) - 11 //https://stackoverflow.com/a/5586652/6365117
    static let l : Int = 88 //length of a part of encrypted string in format base64. This value is different for different key sizes and key types
    static let encryptedDataSize : Int = Int(keySizeInBits/8)
    static let dataFiller : UInt8 = 32
    
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
    var error : Unmanaged<CFError>?
    
    SecKeyGeneratePair(CryParams.parameters as CFDictionary, &pubKey, &privKey)
    
    if let cfdata = SecKeyCopyExternalRepresentation(pubKey!, &error) {
        let data:Data = cfdata as Data
        publicKey = data.base64EncodedString()
//        print("Base64 encoded key:\(publicKey)")
//        print()
        let hexString = data.hexEncodedString()
//        print("Hex public key: \(hexString)")
        let data2 = hexString.hexadecimal()
//        print("Base64 reencoded key:\(data2?.base64EncodedString())")
//        le
        
    }
    
    if let cfdata = SecKeyCopyExternalRepresentation(privKey!, &error) {
        let data:Data = cfdata as Data
//        print("Hex private key: \(data.hexEncodedString())")
        privateKey = data.base64EncodedString()
    }
    
    return (publicKey, privateKey)
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

//func encryptString(_ string: String, with key: SecKey) -> String {
//    let cleanData = string.data(using: .utf8)!
//    let encryptedData = cleanData.encrypt(with: key)
//    return encryptedData.base64EncodedString()
//}
//
//func decryptString(_ encryptedString: String, with key: SecKey) -> String {
//    let encryptedData = Data(base64Encoded: encryptedString, options: [])!
//    let decryptedData = encryptedData.decrypt(with: key)
//    return String(data: decryptedData, encoding: .utf8) ?? "*error*"
//}

