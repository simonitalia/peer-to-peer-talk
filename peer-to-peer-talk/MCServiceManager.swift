//
//  Coordinator.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 09/02/22.
//

import MultipeerConnectivity
import SwiftUI

protocol MCServiceManagerDelegate {
    func connectedDevicesChanged(manager : MCServiceManager, connectedDevices: [String])
    func onTextReceived(manager : MCServiceManager, text: String)
    
}

class MCServiceManager: NSObject, ObservableObject {
    
    // name of service for this app
    private let MCServiceType = "peerToPeerChat"
    
    // identifies each user uniquely in a session
    private let peerId = MCPeerID(displayName: UIDevice.current.name)
    
    /*
        * used when looking for sessions,
        * shows nearby users and allow them to join with us
    */
    private let mcServiceBrowser: MCNearbyServiceBrowser
    
    /*
       * used when creating a session,
       * informs nearby peers we are here and handles invitations
     */
    private let mcServiceAdvertiser: MCNearbyServiceAdvertiser
    
    // handles all multipeer connectivity
    lazy var mcSession : MCSession = {
        let session = MCSession(
            peer: self.peerId,
            securityIdentity: nil,
            encryptionPreference: .required
        )
        
        session.delegate = self
        return session
    }()
    
    var delegate: MCServiceManagerDelegate?
    
    override init() {
        self.mcServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: MCServiceType)
        
        self.mcServiceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: MCServiceType)
        
        super.init()
        
        self.mcServiceAdvertiser.delegate = self
        self.mcServiceAdvertiser.startAdvertisingPeer()
        
        self.mcServiceBrowser.delegate = self
        self.mcServiceBrowser.startBrowsingForPeers()
    }

    deinit {
        self.mcServiceAdvertiser.stopAdvertisingPeer()
        self.mcServiceBrowser.stopBrowsingForPeers()
    }
}

extension MCServiceManager {
	
	func send(message: String) {
		NSLog("%@", "sendMessage: \(message) to \(mcSession.connectedPeers.count) peers,\(mcSession.connectedPeers.self)")
		
		if mcSession.connectedPeers.count > 0 {
			do {
				try self.mcSession.send(message.data(using: .utf8)!, toPeers: mcSession.connectedPeers, with: .reliable)
			}
			catch let error {
				NSLog("%@", "Error for sending: \(error)")
			}
		}
	}
}

extension MCServiceManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    }
}

/*
    * for customized browsing
 */
extension MCServiceManager: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.mcSession, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}

extension MCServiceManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}
