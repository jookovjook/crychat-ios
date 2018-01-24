//
//  Message.swift
//  crychat
//
//  Created by Жека on 21/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

class MessageCell: UITableViewCell{
    @IBOutlet weak var messageLabel: UILabel!
    
    func bind(with: Message){
        self.messageLabel.text = with.message
    }
}

class Message: Block {
    
    var message: String = ""
    var valid: Bool = false
    var from: String = ""
    var to: String = ""
    var with: String = ""
    
    let kc = KeychainSwift()
    
    init(block: JSON, _ selfId : String){
        super.init(block: block)
        
        if(self.data.type != "message") {
            return
        }
        
        let content = self.data.content
        let privateKey = kc.get("privateKey") ?? ""
        
        let key1 = content["key1"]
        var unlockKey = ""
        
        if(key1.error == nil){
            let privKeyJsonString = decryptString(key1.stringValue, with: privKey(from: privateKey)!)
            let privKeyJson = convertSwiftyJSON(text: privKeyJsonString)
            let key = privKeyJson["key"]
            if (key.error == nil){
                unlockKey = key.stringValue
            }else{
                print("failed decoding array")
            }
            
        }
        
        let key2 = content["key2"]
        
        if(key2.error == nil){
            let privKeyJsonString = decryptString(key2.stringValue, with: privKey(from: privateKey)!)
            let privKeyJson = convertSwiftyJSON(text: privKeyJsonString)
            let key = privKeyJson["key"]
            if (key.error == nil){
                unlockKey = key.stringValue
            }else{
                print("failed decoding array")
            }
        }
        
        let tyu = 1
        
        if(unlockKey == ""){
            print("failed unlocking key")
            return
        }else{
            print("unlockKey: \(unlockKey)")
            let encryptedJSON = content["encryptedMessage"]
            if(encryptedJSON.error == nil){
                let encryptedMessage = encryptedJSON.stringValue
                let decryptedJSONString = decryptString(encryptedMessage, with: privKey(from: unlockKey)!)
                print("Unlocked the message: \(decryptedJSONString)")
                let decryptedJSON = convertSwiftyJSON(text: decryptedJSONString)
                
                let from = decryptedJSON["from"]
                if(from.error == nil){
                    self.from = from.stringValue
                }else{
                    return
                }
                
                let to = decryptedJSON["to"]
                if(to.error == nil){
                    self.to = to.stringValue
                }else{
                    return
                }
                
                
                if(!(self.from == selfId || self.to == selfId)){
                    return
                }
                
                self.with = self.from == selfId ? self.to : self.from
                
                let message = decryptedJSON["message"]
                if(message.error == nil){
                    self.message = message.stringValue
                    self.valid = true
                }
            }
        }
        
    }
    
}
