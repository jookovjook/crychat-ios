//
//  Data.swift
//  crychat
//
//  Created by Жека on 25/01/2018.
//  Copyright © 2018 Жека. All rights reserved.
//

import Foundation
import CryptoSwift

func splitData(_ initialData: Data, step: Int, filler: UInt8 = CryParams.dataFiller) -> [Data] {
    var data = initialData
    var appendCount = step - data.count % step
    if(appendCount == step && data.count > 0) { appendCount = 0 }
    data.append(Data(repeating: filler, count: appendCount))
    var splittedData : [Data] = []
    for i in 0...(data.count / step - 1){
        splittedData.append(data[(i*step)..<((i+1)*step)])
    }
    return splittedData
}

extension Data {
    
    private func encryptBlock(with key: SecKey) -> Data {
        var (plainText, plainTextLen, cipherData, cipherText, cipherTextLen) = self.getTools(blockSize: SecKeyGetBlockSize(key))
        SecKeyEncrypt(key, .PKCS1, plainText, plainTextLen, cipherText, &cipherTextLen)
        return cipherData
    }
    
    private func decryptBlock(with key: SecKey) -> Data {
        var (encryptedText, encryptedTextLen, plainData, plainText, plainTextLen) = self.getTools(blockSize: CryParams.bufferSize)
        SecKeyDecrypt(key, .PKCS1, encryptedText, encryptedTextLen, plainText, &plainTextLen)
        return plainData
    }
    
    private func getTools(blockSize: Int) -> (UnsafePointer<UInt8>, Int, Data, UnsafeMutablePointer<UInt8>, Int){
        let initialText = (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: (self.count))
        let initialTextLen = self.count
        
        var finalData = Data(count: blockSize)
        let finalText = finalData.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        })
        let finalTextLen = finalData.count
        
        return (initialText, initialTextLen, finalData, finalText, finalTextLen)
    }
    
    func encrypt(with key: SecKey) -> Data {
        let splittedData = splitData(self, step: CryParams.bufferSize)
        var encryptedData : Data = Data()
        for dataBlock in splittedData {
            encryptedData.append(dataBlock.encryptBlock(with: key))
        }
        return encryptedData
    }
    
    func decrypt(with key: SecKey) -> Data {
        let splittedData = splitData(self, step: CryParams.encryptedDataSize)
        var decryptedData : Data = Data()
        for dataBlock in splittedData {
            decryptedData.append(dataBlock.decryptBlock(with: key))
        }
        return decryptedData
    }
    
    
    
}
