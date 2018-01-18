//
//  Dialog.swift
//  crychat
//
//  Created by Жека on 18/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation
import UIKit
import IGIdenticon

class Dialog {
    
    var publicKey: String = ""
    
    init(){}
    
    init(_ publicKey: String){
        self.publicKey = publicKey
    }
    
}

class DialogCell: UITableViewCell {
    
    @IBOutlet weak var dialogImage: UIImageView!
    @IBOutlet weak var publicKeyLabel: UILabel!
    
    func bind(_ dialog: Dialog){
        self.dialogImage.setPublicKey(dialog.publicKey, width: 44, height: 44)
        self.publicKeyLabel.text = dialog.publicKey
    }
    
}
