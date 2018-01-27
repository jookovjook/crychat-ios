//
//  CryptoSwift.swift
//  crychat
//
//  Created by Жека on 25/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation
import CryptoSwift

extension AES {
    
    convenience init(key: String) throws {
        try self.init(key: key, iv: String(key.reversed()))
    }
    
}
