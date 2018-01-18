//
//  Block.swift
//  crychat
//
//  Created by Жека on 08/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation
import UIKit
import IGIdenticon

class Block{
    
    var id: Int = 0
    var previousHash: String = ""
    var hash: String = ""
    var timestamp: Int = 0
    var data: String = ""
    
    init(block: JSON){
        self.id = block["id"].intValue
        self.previousHash = block["previousHash"].stringValue
        self.hash = block["hash"].stringValue
        self.timestamp = block["timestamp"].intValue
        self.data = block["data"].stringValue
//        print("\(block.rawString())")
    }
    
}

class Message: Block {
    
    var message: String = ""
    var client: String = ""
    var valid: Bool = false
    
    override init(block: JSON){
        super.init(block: block)
        let data = convertSwiftyJSON(text: self.data)
        let message = data["message"]
        if(message.error == nil){
            self.message = message.stringValue
            self.valid = true
        }
        let client = data["client"]
        if(client.error == nil){
            self.client = client.stringValue
        }
    }
    
}

class CellBlock: UITableViewCell{
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var identIcon: UIImageView!
    
    func bind(_ message: Message){
        label.text = message.message
        topLine.isHidden = message.id <= 1
        identIcon.image = Identicon().icon(from: message.client, size: CGSize(width: identIcon.frame.width, height: identIcon.frame.height))
    }
    
}
