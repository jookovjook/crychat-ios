//
//  NewAddressVC.swift
//  crychat
//
//  Created by Жека on 17/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit
import IGIdenticon

class NewAddressVC: UIViewController {

    @IBOutlet weak var publicKeyLabel: UILabel!
    @IBOutlet weak var privateKeyLabel: UILabel!
    
    @IBOutlet weak var identIcon: UIImageView!
    
    @IBAction func generateAction(_ sender: Any) {
        let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(512)
        publicKeyLabel.text = publicKey.base64EncodedString()
        privateKeyLabel.text = privateKey.base64EncodedString()
        identIcon.setPublicKey(publicKey.base64EncodedString())
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.newAddressDelegate.onAddressGenerated(privateKeyLabel.text ?? "", publicKeyLabel.text ?? "")
        self.cancelAction(self)
    }
    var newAddressDelegate : NewAddressDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateAction(self)
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    

}

protocol NewAddressDelegate {
    func onAddressGenerated(_ privateKey: String, _ publicKey: String)
}
