//
//  DialogVC.swift
//  crychat
//
//  Created by Жека on 21/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit
import KeychainSwift

class DialogVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kc = KeychainSwift()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomGuideConstraint: NSLayoutConstraint!
    var dialog: Dialog!
    
    @IBOutlet weak var messageTF: UITextField!
    @IBAction func sendAction(_ sender: Any) {
        sendMessage(messageTF.text ?? "", to: dialog.messagesList[0].with, completionHandler: { success in
            if(success){
                self.messageTF.text = ""
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialog.messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageCell
        messageCell.bind(with: dialog.messagesList[indexPath.row])
        return messageCell
    }

}
