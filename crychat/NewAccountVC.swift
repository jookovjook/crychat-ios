//
//  NewAccountVC.swift
//  crychat
//
//  Created by Жека on 17/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit
import IGIdenticon

class NewAccountVC: UIViewController {

    @IBOutlet weak var publicKeyLabel: UILabel!
    @IBOutlet weak var privateKeyLabel: UILabel!
    
    @IBOutlet weak var identIcon: UIImageView!
    
    @IBAction func generateAction(_ sender: Any) {
        let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(512)
        publicKeyLabel.text = publicKey.base64EncodedString()
        privateKeyLabel.text = privateKey.base64EncodedString()
        identIcon.image = Identicon().icon(from: publicKey.base64EncodedString(), size: CGSize(width: identIcon.frame.width, height: identIcon.frame.height))
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateAction(self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

protocol NewAddressDelegate {
    func onAddressGenerated(_ privateKey: String, publicKey: String)
}
