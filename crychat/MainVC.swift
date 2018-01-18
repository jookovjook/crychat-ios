//
//  ViewController.swift
//  crychat
//
//  Created by Жека on 08/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit
//import SwiftyRSA

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
        
        
        
        for i in 1...10 {
            let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(512) //384
            print("private : \(privateKey.base64EncodedString())")
            print("----------")
            print("public : \(publicKey.base64EncodedString())")
            print(" ")
        }
        
        
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

