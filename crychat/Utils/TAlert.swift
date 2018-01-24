//
//  TAlert.swift
//  tender.admin
//
//  Created by Жека on 30/11/2017.
//  Copyright © 2017 Жека. All rights reserved.
//

import UIKit

class TAlert: UIView {
    
    let statusBarHeight: CGFloat
    let baseWindow : UIWindow
    var messageLabel = UILabel()
    let iphoneXStatusBarHeight = CGFloat(88)
    let autoDismiss: Bool
    
    init(_ message: String = "Network issue", autoDismiss: Bool = false, error : Bool = true){
        let width = UIScreen.main.bounds.width
//        let height = UIScreen.main.bounds.height
        let isX = UIApplication.shared.statusBarFrame.height > CGFloat(30)
        self.statusBarHeight = isX ? iphoneXStatusBarHeight : UIApplication.shared.statusBarFrame.height
        self.baseWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: width, height: statusBarHeight))
        self.autoDismiss = autoDismiss
        super.init(frame: CGRect(x: 0, y: -statusBarHeight, width: width, height: statusBarHeight))
        self.isUserInteractionEnabled = true
        
        self.backgroundColor = error ? UIColor.red : UIColor.init(red: 149/255, green: 191/255, blue: 192/255, alpha: 1)
        
        let fontSize = CGFloat(12)
        
        if(!error){
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hide)))
        }
        
        //        if(fontSize * 2 < (statusBarHeight - 4)){
        //            messageLabel.frame = CGRect(x: 2, y: frame.height - fontSize - 2, width: frame.width - 4, height: fontSize)
        //        }else{
        //            messageLabel.frame = CGRect(x: 2, y: 2, width: frame.width - 4, height: frame.height - 4)
        //        }
        
        //        messageLabel.frame = fontSize * 2 < (statusBarHeight - 4) ?
        //            CGRect(x: 2, y: frame.height - fontSize - 2, width: frame.width - 4, height: fontSize) :
        //            CGRect(x: 2, y: 2, width: frame.width - 4, height: frame.height - 4)
        
        let addHeight = isX ? UIApplication.shared.statusBarFrame.height : CGFloat(0)
        messageLabel.frame = CGRect(x: 2, y: 2 + addHeight, width: frame.width - 4, height: frame.height - 4 - addHeight)
        
        //        messageLabel.frame = CGRect(x: 2, y: frame.height - fontSize - 2, width: frame.width - 4, height: fontSize)
        messageLabel.font = UIFont.systemFont(ofSize: fontSize)
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.white
        self.addSubview(messageLabel)
        
        //        let baseView = UIView(frame: UIScreen.main.bounds)
        //        baseView.isUserInteractionEnabled = false
        //        baseView.addSubview(self)
        
        self.baseWindow.isUserInteractionEnabled = false
        self.baseWindow.windowLevel = UIWindowLevelStatusBar + 1
        self.baseWindow.addSubview(self)
        self.baseWindow.makeKeyAndVisible()
    }
    
    func setMessage(_ message: String = "Network Issue"){ messageLabel.text = message }
    
    func show(hide: Bool = false){
        let k = hide ? -1.0 : 1.0
        UIView.animate(withDuration: 0.4,
                       animations: { () -> Void in
                        self.transform = CGAffineTransform(translationX: 0, y: CGFloat(k * Double(self.statusBarHeight)))
        }, completion: { (value) -> Void in
            self.baseWindow.isUserInteractionEnabled = !hide
            if(self.autoDismiss && !hide){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: {
                    self.hide()
                })
            }
        })
        
        
    }
    
    @objc func hide(){
        show(hide: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

