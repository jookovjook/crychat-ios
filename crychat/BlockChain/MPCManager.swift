////
////  MPCManager.swift
////  crychat
////
////  Created by Жека on 25/01/2018.
////  Copyright © 2018 Жека. All rights reserved.
////
//
//import UIKit
//import MultipeerConnectivity
//
//
////class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
//
//    var session: MCSession!
//    var peer: MCPeerID!
//    var browser: MCNearbyServiceBrowser!
//    var advertiser: MCNearbyServiceAdvertiser!
//    
//    var foundPeers = [MCPeerID]()
//    var invitationHandler: ((Bool, MCSession?)->Void)!
//    
//    var delegate: MPCManagerDelegate?
//    
//    override init() {
//        super.init()
//        peer = MCPeerID(displayName: UIDevice.current.name)
//        session = MCSession(peer: peer)
//        session.delegate = self
//        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "appcoda-mpc")
//        browser.delegate = self
//        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "appcoda-mpc")
//        advertiser.delegate = self
//    }
//    
//    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
//        foundPeers.append(peerID)
//        delegate?.foundPeer()
//    }
//    
//    func browser(_ browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
//        for (index, aPeer) in foundPeers.enumerated(){
//            if aPeer == peerID {
//                foundPeers.remove(at: index)
//                break
//            }
//        }
//        delegate?.lostPeer()
//    }
//    
//    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
//        print(error.localizedDescription)
//    }
//
//}
//
//protocol MPCManagerDelegate {
//    func foundPeer()
//    func lostPeer()
//    func invitationWasReceived(fromPeer: String)
//    func connectedWithPeer(peerID: MCPeerID)
//}

