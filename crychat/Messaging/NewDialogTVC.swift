//
//  NewDialogTVC.swift
//  crychat
//
//  Created by Жека on 24/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit

class NewDialogTVC: UITableViewController {

    @IBOutlet weak var publicKeyTV: UITextView!
    @IBOutlet weak var messageTV: UITextView!
    @IBAction func sendAction(_ sender: Any) {
        sendMessage(messageTV.text ?? "", to: publicKeyTV.text ?? "", completionHandler: { success in
            if(success){
                
//                navigationItem.pop
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publicKeyTV.delegate = self
        messageTV.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
