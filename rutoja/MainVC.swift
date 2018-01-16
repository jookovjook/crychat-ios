//
//  ViewController.swift
//  rutoja
//
//  Created by Жека on 08/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit
import SwiftyRSA

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomGuideConstraint: NSLayoutConstraint!
    
    @IBAction func sendAction(_ sender: Any) {
        let uuid : String = (UIDevice.current.identifierForVendor?.uuidString)!
        let data = ["message": inputTF.text ?? "", "client" : uuid]
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: data,
            options: .sortedKeys
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
                    networkRequest(addURL: "block/add.php", json : ["data" : theJSONText ], completionHandler: {json, error, msg in
                        if(error == 0){
                            self.chain.reload(completionHandler : {_ in
                                self.inputTF.text = ""
                                self.tableView.reloadData()})
                        }else{
                            print("Error \(error): \(msg)")
                        }
            
                    })
        }

    }
    
    @IBOutlet weak var inputTF: UITextField!
    
    var chain : Chain = Chain()

    override func viewDidLoad() {
        
        chain = Chain(completionHandler: {_ in
            self.tableView.reloadData()
        })
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
//
//        let publicKey = try? PublicKey(base64Encoded: "MEwwDQYJKoZIhvcNAQEBBQADOwAwOAIxAMwchQ4lNZLwTJk0GYJFlhEqFgFQJRjh x/QRCU25Ibqy3d8c3NMSZTqbpAKPZ9LaVwIDAQAB")
//
//        let privateKey = try? PrivateKey(base64Encoded: "MIIBCwIBADANBgkqhkiG9w0BAQEFAASB9jCB8wIBAAIxAMwchQ4lNZLwTJk0GYJF lhEqFgFQJRjhx/QRCU25Ibqy3d8c3NMSZTqbpAKPZ9LaVwIDAQABAjA1aBD4jovi ErY4MAWsrICDpTt0xH+wbwLnE6QwO9iMk8LNmaE+mRwYf6OI60CFJOECGQDqopbG qQrcLOCOyO6aio1ZAxklyP35xZsCGQDesmocDWP0nQyFWUMxRRnXvy2E1RT8h/UC GQDpposavU8xPgdIaNMiVgK3txwdwm8XgS0CGBE3xCJ1GpRQDCbHNv25NP1MR62s d9nqfQIZAIjdN1QhQH/P4ADNd9GF/3fxnP4t7ye1KQ==")
//
//        let str1 = try? publicKey?.base64String()
//        let str2 = try? privateKey?.base64String()
//
//        print("publicKey: \(str1)")
//        print("privateKey: \(str2)")
//
//        let encrypted = try? EncryptedMessage(base64Encoded: "c025586670f030a505b70f0b4bc6c97750f9f7444dda6e9f8aaa8043fd35e1c3ccaf95efd3297ae443f6200075edc168")
//        let clear = try? encrypted?.decrypted(with: privateKey!, padding: .PKCS1)
//
//        print("decrypted: \(clear)")
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomGuideConstraint?.constant = 0.0
            } else {
                self.bottomGuideConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chain.messagesChain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellBlock =  tableView.dequeueReusableCell(withIdentifier: "cellBlock", for: indexPath) as! CellBlock
        cellBlock.bind(chain.messagesChain[indexPath.row])
        return cellBlock
    }

}

