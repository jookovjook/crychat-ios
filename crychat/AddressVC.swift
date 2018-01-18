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
class AddressVC: UIViewController {

    @IBOutlet weak var identIcon: UIImageView!
    @IBOutlet weak var publicKeyLabel: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBAction func createNewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "newAddressSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let kc = KeychainSwift()
        let publicKey = kc.get("publicKey")
        if(publicKey != nil){
            showPublicKey(publicKey!)
            nextButton.isEnabled = true
        }else{
            showPublicKey("")
            nextButton.isEnabled = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPublicKey(_ publicKey: String){
        publicKeyLabel.text = publicKey
        identIcon.image = Identicon().icon(from: publicKey, size: CGSize(width: identIcon.frame.width, height: identIcon.frame.height))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
