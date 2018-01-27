//
//  Chain.swift
//  crychat
//
//  Created by Жека on 08/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation
import KeychainSwift

class Chain {
    
    var chain : [Block] = []
    var dialogsChain : [Dialog] = []
    var dialogsList : [String] = []
    
    let kc = KeychainSwift()
    
    
    init(chain: JSON){
        for block in (chain.array)!{
            self.chain.append(Block(block: block))
        }
    }
    
    init(completionHandler: @escaping (Bool) -> ()){
        reload(completionHandler: completionHandler)
    }
    
    init(){}
    
    func addMessage(_ message: Message){
        if(!dialogsList.contains(message.with)){
            dialogsChain.append(Dialog(message.with))
            dialogsList.append(message.with)
        }
        let index = dialogsList.index(of: message.with)
        dialogsChain[index!].messagesList.append(message)
    }
    
    func reload(completionHandler: @escaping (Bool) -> ()){
        networkRequest(addURL: "chain/get.php", completionHandler: { json, error, msg in
            self.chain.removeAll()
            self.dialogsChain.removeAll()
            self.dialogsList.removeAll()
//            print("Chain: \(json)")
            if(error == 0){
                let chain = json["chain"].array
                for jsonBlock in chain! {
                    let block = Block(block: jsonBlock)
                    self.chain.append(block)
                    let publicKey = self.kc.get("publicKey") ?? ""
                    if(block.data.type == "message"){
                        let message = Message(block: jsonBlock, publicKey)
                        if message.valid {
                            self.addMessage(message)
                        }
                    }
                    
                }
                completionHandler(true)
            }
            completionHandler(false)
            
        })
    }
    
}
