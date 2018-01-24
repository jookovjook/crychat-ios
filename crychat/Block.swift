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
    var data: BlockData
    
    init(block: JSON){
        self.id = block["id"].intValue
        self.previousHash = block["previousHash"].stringValue
        self.hash = block["hash"].stringValue
        self.timestamp = block["timestamp"].intValue
        self.data = BlockData(block["data"].stringValue)
    }
    
}

class BlockData {
    
    var type: String = ""
    var content: JSON
    
    init(_ strData: String){
        let jsonData = convertSwiftyJSON(text: strData)
        
        let type = jsonData["type"]
        if(type.error == nil){
            self.type = type.stringValue
        }
        
        let content = jsonData["content"]
        self.content = content.error == nil ? content : JSON()
//        print("Content: \(self.content)")
    }
    
}



class CellBlock: UITableViewCell{
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var identIcon: UIImageView!
    
    func bind(_ message: Message){
        label.text = message.message
        topLine.isHidden = message.id <= 1
        identIcon.image = Identicon().icon(from: message.with, size: CGSize(width: identIcon.frame.width, height: identIcon.frame.height))
    }
    
}
