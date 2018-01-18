//
//  AddressVC.swift
//  crychat
//
//  Created by Жека on 17/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit
import KeychainSwift
import IGIdenticon

class AddressVC: UIViewController, NewAddressDelegate {

    @IBOutlet weak var identIcon: UIImageView!
    @IBOutlet weak var publicKeyLabel: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBAction func createNewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "newAddressSegue", sender: self)
    }
    
    let kc = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let publicKey = kc.get("publicKey")
        showPublicKey(publicKey ?? "")
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    func showPublicKey(_ publicKey: String){
        publicKeyLabel.text = publicKey
        identIcon.setPublicKey(publicKey)
//        identIcon.image = Identicon().icon(from: publicKey, size: CGSize(width: identIcon.frame.width, height: identIcon.frame.height))
        if(publicKey == ""){
            nextButton.isEnabled = false
            identIcon.alpha = 0
        }else{
            nextButton.isEnabled = true
            identIcon.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newAddressSegue"){
            let destination = segue.destination as! NewAddressVC
            destination.newAddressDelegate = self
        }
    }
    
    func onAddressGenerated(_ privateKey: String, _ publicKey: String) {
        kc.set(publicKey, forKey: "publicKey")
        kc.set(privateKey, forKey: "privateKey")
        showPublicKey(publicKey)
    }

}
