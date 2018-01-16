//
//  Chain.swift
//  rutoja
//
//  Created by Жека on 08/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation

class Chain {
    
    var chain : [Block] = []
    var messagesChain : [Message] = []
    
    init(chain: JSON){
        for block in (chain.array)!{
            self.chain.append(Block(block: block))
        }
    }
    
    init(completionHandler: @escaping (Bool) -> ()){
        reload(completionHandler: completionHandler)
    }
    
    init(){}
    
    func reload(completionHandler: @escaping (Bool) -> ()){
        networkRequest(addURL: "chain/get.php", completionHandler: { json, error, msg in
            self.chain.removeAll()
            self.messagesChain.removeAll()
            if(error == 0){
                let chain = json["chain"].array
                for block in chain! {
                    self.chain.append(Block(block: block))
                    let message = Message(block: block)
                    if message.valid {
                        self.messagesChain.append(message)
                    }
                }
                completionHandler(true)
            }
            completionHandler(false)
            
        })
    }
    
}
