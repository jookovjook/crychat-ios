//
//  Messaging.swift
//  crychat
//
//  Created by Жека on 24/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation
import KeychainSwift

func sendMessage(_ message: String, to : String, completionHandler: @escaping (Bool) -> ()){
    let kc = KeychainSwift()
    let publicKey = kc.get("publicKey") ?? ""
    let (pub_Key, priv_Key) = generateKeyPair()
    let encryptedData = convertToString(["from" : publicKey, "to" : to, "message" : message])
    let encryptedMessage = encryptString(encryptedData, with: pubKey(from: pub_Key)!)
    let key1 = encryptString(convertToString(["key":priv_Key]), with: pubKey(from: publicKey)!)
    let key2 = encryptString(convertToString(["key":priv_Key]), with: pubKey(from: to)!)
    let json = [ "type" : "message", "content" : [ "key1" : key1, "key2" : key2, "encryptedMessage" : encryptedMessage ]] as [String : Any]
    let jsonText = convertToString(json)
    print("data: \(jsonText)")
    if(jsonText != ""){
        networkRequest(addURL: "block/add.php", json : ["data" : jsonText ], completionHandler: {json, error, msg in
            if(error == 0){
                completionHandler(true)
            }
            completionHandler(false)
            
        })
    }
    completionHandler(false)
}
