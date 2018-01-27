//
//  TestVC.swift
//  crychat
//
//  Created by Жека on 25/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit
import Darwin

class TestVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentIP(completion: {result in
            print("Got IP: \(result)")
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentIP(completion: @escaping (String?) -> ()){
        
        if let checkedUrl = URL(string: "https://api.ipify.org?format=json") {
            getDataFromUrl(urL: checkedUrl, completion: { (data) -> Void in
                
//                var parseError: NSError?
                
                do{
                let parsedObject: AnyObject? = try JSONSerialization.jsonObject(with: data!,
                                                                            options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    if let jsonIP = parsedObject as? NSDictionary{
                        DispatchQueue.main.async{
                            completion(jsonIP["ip"] as? String)
                        }
                    }
                }catch{
                    completion("*error*")
                }
                
                
            })
        }
        
    }
    
    func getDataFromUrl(urL: URL, completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: urL) { (data, response, error) in
            completion(data)
            }.resume()
    }
    

}
