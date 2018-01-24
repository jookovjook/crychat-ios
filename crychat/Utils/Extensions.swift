//
//  Extensions.swift
//  crychat
//
//  Created by Жека on 18/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import UIKit
import IGIdenticon

extension UIImageView {
    
    func setPublicKey(_ publicKey: String, width: Int = -1, height: Int = -1){
        self.setString(publicKey, width: width, height: height)
    }
    
    func setString( _ string: String, width: Int = -1, height: Int = -1){
        let h = height >= 0 ? CGFloat(height) : self.frame.height
        let w = width >= 0 ? CGFloat(width) : self.frame.width
        self.image = Identicon().icon(from: string, size: CGSize(width: w, height: h))
    }
    
}

extension NewDialogTVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        update()
    }
    
    func update(){
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
}

extension AddressSettingsTVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        update()
    }
    
    func update(){
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        identIcon.setPublicKey(publicKeyTV.text)
    }
}

extension String {
    func subString(startIndex: Int, endIndex: Int) -> String {
        let end = (endIndex - self.count) + 1
        let indexStartOfText = self.index(self.startIndex, offsetBy: startIndex)
        let indexEndOfText = self.index(self.endIndex, offsetBy: end)
        let substring = self[indexStartOfText..<indexEndOfText]
        return String(substring)
    }
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
}

extension Data {

    func utf8String() -> String? {
        let characterSet = CharacterSet(charactersIn: "<>")
        let nsData = NSData.init(data: self)
        return nsData.description.trimmingCharacters(in: characterSet)
    }

}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
    
    func hexEncodedStringFast(options: HexEncodingOptions = []) -> String {
        let hexDigits = Array((options.contains(.upperCase) ? "0123456789ABCDEF" : "0123456789abcdef").utf16)
        var chars: [unichar] = []
        chars.reserveCapacity(2 * count)
        for byte in self {
            chars.append(hexDigits[Int(byte / 16)])
            chars.append(hexDigits[Int(byte % 16)])
        }
        return String(utf16CodeUnits: chars, count: chars.count)
    }
}

