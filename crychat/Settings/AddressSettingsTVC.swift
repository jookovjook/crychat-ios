//
//  AddressSettingsTVC.swift
//  crychat
//
//  Created by Жека on 22/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit

class AddressSettingsTVC: UITableViewController {

    @IBOutlet weak var publicKeyTV: UITextView!
    @IBOutlet weak var privateKeyTV: UITextView!
    @IBOutlet weak var identIcon: UIImageView!
    @IBAction func generateAction(_ sender: Any) {
        let (publicKey, privateKey) = generateKeyPair()
        setKeys(privateKey, publicKey)
    }
    @IBAction func adress_1(_ sender: Any) {
        setKeys("MIIBOgIBAAJBAL737WSWO0GbB8NzHQTZqQP5MyIfrhvplKRGH1kaCWw4CC4LwRuOukNFTzgsDkOpDDrAT06TNFO2O8d6bOpAQW0CAwEAAQJATzVomtMRSvnxs2jYvX1GdGZ1hg7b2an9xFFtiTiade7kQe8cw0ZakK+G/UyADg1kKflFd3eUrcAdUdaHec6KpQIhAOL2sU3a76whRlxxK8ktalGTAEkEq0HAv9NtQsnUjQfDAiEA12Zac/u9UMzLJRj1UFX17buxTPYR1f0Gq9b5cJ8wLw8CIGIJt7ruqHrNAMyrogNLl9JW0le4KZXEgdf9KU1vf9/rAiAJuoW7V1NlotpKAqaRylAhPKj1YOfNUnBKsprxiz8R4QIhALGASZydiw1hYHGz84ttlMQW2Qh071X8V2jbt09BjhXB","MEgCQQC+9+1kljtBmwfDcx0E2akD+TMiH64b6ZSkRh9ZGglsOAguC8EbjrpDRU84LA5DqQw6wE9OkzRTtjvHemzqQEFtAgMBAAE=")
    }
    
    @IBAction func address_2(_ sender: Any) {
        setKeys("MIIBOwIBAAJBALaGC8cyXHk/pG056ee6Tf9Ux95bdoHXkCxWPEaPxwDyCX7xwXNFiz76H/9aIsvM8W72400j3Vx3PZ+b5rZnRq0CAwEAAQJAIURzVx41vp+773CT0nmhh71DJKMVCXtpursJB29jPSeQfYUzXA0TBzXCp6PCcWv/Eng7g/rSEyRMssEGoPBKHQIhAP5cqU7l/k4QP183iC+xOiYxMmmhLQZtZXj1IgwYnFaXAiEAt7Lz4Y/cuPGW/JZj2pqIJzyq/lQb6j6YCla6NGpWWVsCIQDY9nbgOqPhOFClyjta2uQLwbkLipRaQCPmuclR4ggwfwIhAJwAtWyRJ/lH8dmAPjyfj5ECzJRACZTco3HkRS3OQJaRAiAuwac1yIZxMpmTGfcJr597uOg6WQREKm9aA/Q+FSHRFg==","MEgCQQC2hgvHMlx5P6RtOennuk3/VMfeW3aB15AsVjxGj8cA8gl+8cFzRYs++h//WiLLzPFu9uNNI91cdz2fm+a2Z0atAgMBAAE=")
    }

    @IBAction func address_3(_ sender: Any) {
        setKeys("MIIBOwIBAAJBAMIUSpUIM/0FXlx6lMuMo5gIQYK6VxDEInMfV1jWyA9gKLUdS8+ZiUW218gCCXL2h50pdOoKuyjRuOvhYNY8g+MCAwEAAQJAJGBAQGGquNxWPNge5m3kRb0aZkG9yt8wI8q2iOis07Ca/SAvx52QFZl0LFM5hFSJk4cnZetK3gDW1iE0H3QQNQIhAO8mDsiND1ot/0ik2fHf7rTye5f96GtPf8jwqtRfVzKnAiEAz8E88si3mkjmohjHqgsiywbynm3iywif8CYPr3lXOGUCIQCEl6U6rHsGlNolfMEZyf6fdJHyA2UJmlpPHqCYfwPpoQIhALl/fH/6n5Tuip8pKP23O7Wz2mWDEADhDo1KLq8q1KnRAiAgfOIwXYNFivmvBhgYFGUVk4H9tn2pI/1Kt7eeYz954g==","MEgCQQDCFEqVCDP9BV5cepTLjKOYCEGCulcQxCJzH1dY1sgPYCi1HUvPmYlFttfIAgly9oedKXTqCrso0bjr4WDWPIPjAgMBAAE=")
    }
    
    func setKeys(_ privateKey: String, _ publicKey: String){
        publicKeyTV.text = publicKey
        privateKeyTV.text = privateKey
        update()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        newAddressDelegate.onAddressGenerated(privateKeyTV.text ?? "", publicKeyTV.text ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    var newAddressDelegate : NewAddressDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publicKeyTV.delegate = self
        privateKeyTV.delegate = self
        generateAction(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

protocol NewAddressDelegate {
    func onAddressGenerated(_ privateKey: String, _ publicKey: String)
}
