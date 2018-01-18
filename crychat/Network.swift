//
//  Network.swift
//  tender.admin
//
//  Created by Жека on 27/11/2017.
//  Copyright © 2017 Жека. All rights reserved.
//

import Foundation
import UIKit
//import KeychainSwift
//import Firebase


func networkRequest(addURL:String, json:[String:Any] = [:], vc: UIViewController! = nil, verbose: Bool = true, completionHandler: @escaping (JSON, Int, String) -> ()){
    //Add extra parametres here
    
    request(addURL: addURL, json: json, vc: vc, verbose: verbose, completionHandler: completionHandler)
    
}



func request(addURL:String, json:[String:Any], vc: UIViewController! = nil, verbose: Bool = true, completionHandler: @escaping (JSON, Int, String) -> ()){
    errorHandlingRequest(addURL: addURL, json: json, completionHandler: {jsonResult, error, msg in
        completionHandler(jsonResult, error, msg)
    })
}

func errorHandlingRequest(addURL:String, json:[String:Any], completionHandler: @escaping (JSON, Int, String) -> ()){
    pushReqSafe(addURL: addURL, json: json, completionHandler: {result, success in
        if(success){
            let jsonResult = convertSwiftyJSON(text: result)
            if (jsonResult.error != nil) {
                completionHandler(jsonResult, 401, jsonResult.error.debugDescription)
                return
            }
            let error = jsonResult["error"]
            if (error.error != nil) {
                completionHandler(jsonResult, 401, error.error.debugDescription)
                return
            }
            if (error.intValue != 0) {
                let msg = jsonResult["msg"]
                if(msg.error != nil){
                    completionHandler(jsonResult, error.intValue, msg.error.debugDescription)
                    return
                }else{
                    completionHandler(jsonResult, error.intValue, msg.stringValue)
                    return
                }
            }
            completionHandler(jsonResult, 0, "OK")
        }else{
            completionHandler([:], 401, "Network issue")
        }
    })
}

extension UIViewController {
    func showErrorAlert(_ error: Int, _ body: String){
        let refreshAlert = UIAlertController(title: "Error " + String(error), message: body, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(refreshAlert, animated: true, completion: nil)
    }
}

