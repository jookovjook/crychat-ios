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
        if(publicKey == ""){
            identIcon.alpha = 0
        }else{
            identIcon.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newAddressSegue"){
            let destination = segue.destination as! AddressSettingsTVC
            destination.newAddressDelegate = self
        }
    }
    
    func onAddressGenerated(_ privateKey: String, _ publicKey: String) {
        kc.set(publicKey, forKey: "publicKey")
        kc.set(privateKey, forKey: "privateKey")
        showPublicKey(publicKey)
    }

}
