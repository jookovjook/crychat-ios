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
        let jsonText = convertToString(["message": inputTF.text ?? "", "client" : uuid])
        if(jsonText != ""){
            networkRequest(addURL: "block/add.php", json : ["data" : jsonText ], completionHandler: {json, error, msg in
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellBlock =  tableView.dequeueReusableCell(withIdentifier: "cellBlock", for: indexPath) as! CellBlock
//        cellBlock.bind(chain.messagesChain[indexPath.row])
        return cellBlock
    }

}

