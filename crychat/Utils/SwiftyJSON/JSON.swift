//
//  JSON.swift
//  crychat
//
//  Created by Жека on 21/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation

func convertToString(_ data : [String : Any]) -> String {
    if let theJSONData = try?  JSONSerialization.data(
        withJSONObject: data,
        options: .sortedKeys
        ),
        let theJSONText = String(data: theJSONData,
                                 encoding: String.Encoding.utf8) {
        return theJSONText
        
    }
    return ""
}
