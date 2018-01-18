//
//  Extensions.swift
//  crychat
//
//  Created by Жека on 18/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation
import UIKit
import IGIdenticon

extension UIImageView {
    
    func setPublicKey(_ publicKey: String, width: Int = -1, height: Int = -1){
        self.setString(publicKey, width: width, height: height)
    }
    
    func setString( _ string: String, width: Int = -1, height: Int = -1){
        let h = height >= 0 ? CGFloat(height) : self.frame.height
        let w = width >= 0 ? CGFloat(width) : self.frame.width
        self.image = Identicon().icon(from: string, size: CGSize(width: w, height: h))
    }
    
}
