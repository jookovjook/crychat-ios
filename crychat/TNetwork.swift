//
//  TNetwork.swift
//  Tender.Test
//
//  Created by Руслан on 21.05.17.
//  Copyright © 2017 Руслан. All rights reserved.
//

import UIKit
import SystemConfiguration
import Alamofire

let dels = [0.0, 0.0, 0.001, 0.01, 0.5, 0.001, 0.01, 1.0, 0.1, 0.001, 1.5, 0.0]

func pushReqClassic(addURL:String, json:[String:Any], completionHandler: @escaping (String,Bool) -> ()){
    let tourl = Constants().mainUrl+addURL
    
    let headers = [ "Content-Type" : "application/json"]
    let myUrl = URL(string: tourl)
    var responseString = ""
    var AppVersion = "error"
    let systemVersion = UIDevice.current.systemVersion
    let ConstantsSafe = Constants()
    if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
        AppVersion = version
    }
    
    var jsonNew = json
    jsonNew["AppVersion"] = AppVersion
    jsonNew["Device"] = "iOS" + systemVersion
    
    let parameters = jsonNew
    
//    print("pushReq url:\(myUrl!) jsonNew:\(jsonNew)")
    
    Alamofire.request(myUrl!,
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: headers).responseJSON { response in
                        
//                        print("pushReq responseData:\(response.data) ")
                        
                        if let data = response.data, let strData = String(data: data, encoding: .utf8) {
//                            print("pushReq responseString:\(strData) ")
                            responseString = strData
                            completionHandler(responseString, true)
                            
                        }else{
                            completionHandler("error", false)
                            
                        }
                        
    }
    
}

func pushReqSafe(level : Int = 0, addURL: String, json:[String: Any], completionHandler: @escaping (String, Bool) -> ()){
    var delay = Double(level + (level - dels.count)*(level - dels.count))
    if (delay > 60) { delay = 60 }
    if(level >= dels.count) {
        completionHandler("", false)
    }else{
        delay = Double(dels[level])
    }
    if(level > 2){ showNetworkAlert() }
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
        pushReqClassic(addURL: addURL, json: json, completionHandler: {response, success in
            let jsonResult = convertSwiftyJSON(text: response)
            if(success == false || response == "" || jsonResult.error != nil){
                pushReqSafe(level: level + 1, addURL: addURL, json: json, completionHandler: completionHandler)
            }else{
                showNetworkAlert(hide: true)
                completionHandler(response, true)
            }
        })
    })
}

func showNetworkAlert(hide : Bool = false){
    if((UIApplication.shared.delegate as! AppDelegate).tAlert == nil){
        do{
            (UIApplication.shared.delegate as! AppDelegate).tAlert = TAlert()
        }
    }
    if(hide){
        (UIApplication.shared.delegate as! AppDelegate).tAlert?.hide()
    }else{
        (UIApplication.shared.delegate as! AppDelegate).tAlert?.show()
    }
}


func convertToDictionary(text: String) -> [String: Any]? {
    let jsonData = text.data(using: String.Encoding.utf8)
    let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
    //print(dictionary!)
    return dictionary as! [String : Any]?
    
}

func convertSwiftyJSON(text: String) -> JSON {
    let dataFromString = text.data(using: .utf8, allowLossyConversion: false)
    if let data = dataFromString {
        let json = JSON(data)
        return json
    }else{
        return JSON()
    }
}

struct Constants {
    #if RELEASE
    let mainUrl = "https://rutoja.space/"
    #else
    let mainUrl = "https://rutoja.space/"
    #endif
}



