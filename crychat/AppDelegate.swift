//
//  AppDelegate.swift
//  crychat
//
//  Created by Жека on 08/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit
import CryptoSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tAlert: TAlert?
//    var mpcManager: MPCManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        encryptionsTest()
//        mpcManager = MPCManager()
        return true
    }
    
    func encryptionsTest(_ doit: Bool = true){
        if(!doit){return}
        do {
            //            let aes2 = try AES(key: )
            let key = "passwordpassword"
            let iv = String(key.reversed())
            let aes = try AES(key: key) // aes128
            let ciphertext = try aes.encrypt(Array("Nullam quis risus eget urna mollis ornfsdhfskjfsjkhfksdf suihf8w4infsjk o4suf biubrf oi refekljdnfo3 irufnjklr3fn iou3rnfl npeuwifn p349io relkfsare vel eu leo.".utf8))
            var encryptedData = Data()
            for item in ciphertext{
                encryptedData.append(item)
            }
            print("Encrypted string: \(encryptedData.base64EncodedString())")
            let decryptedTxt = try aes.decrypt(ciphertext)
            var data = Data()
            for item in decryptedTxt {
                data.append(item)
            }
            let string = String(data: data, encoding: .utf8) ?? "*error*"
            print("Decrypted string: \(string)")
        } catch { }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

