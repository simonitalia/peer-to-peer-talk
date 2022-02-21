//
//  Coordinator.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 09/02/22.
//

import MultipeerConnectivity
import SwiftUI

protocol MCServiceManagerDelegate {
    func onConnectedPeersChanged(manager: MCServiceManager, connectedPeers: [String])
	func onNewMessageReceived(manager: MCServiceManager, message: Message)
}

class MCServiceManager: NSObject, ObservableObject {
	
	// name of service for this app
	enum ServiceType {
		static let name = "peerToPeerTalk"
	}
	
	@Published var connectedPeers = [String]()
	@Published var receivedMessages = [Message]()
	
    // identifies each user uniquely in a session
	private let peerId: MCPeerID
    
    /*
        * used when looking for sessions,
        * shows nearby users and allow them to join with us
    */
    private let serviceBrowser: MCNearbyServiceBrowser
    
    /*
       * used when creating a session,
       * informs nearby peers we are here and handles invitations
     */
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    
    // handles all multipeer connectivity
    lazy var session : MCSession = {
        let session = MCSession(
            peer: self.peerId,
            securityIdentity: nil,
            encryptionPreference: .required
        )
        
        session.delegate = self
        return session
    }()
    
    var delegate: MCServiceManagerDelegate?
    
	init(user: User) {
		self.peerId = MCPeerID(displayName: user.name)
		self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: ServiceType.name)
        
        self.serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: ServiceType.name)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }

    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
	
	func presentMCPeerBrowserViewController(serviceManager: MCServiceManager) -> MCPeerBrowserViewController {
		return MCPeerBrowserViewController(serviceManager: serviceManager)
	}
	
	func send(message: Message) {
		NSLog("%@", "sendMessage: \(message) to \(session.connectedPeers.count) peers,\(session.connectedPeers.self)")
		
		if session.connectedPeers.count > 0 {
			do {
				let data = try JSONEncoder().encode(message)
				try self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
		
			} catch let error {
				NSLog("%@", "Error sending message: \(error)")
			}
		}
	}
}

extension MCServiceManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
		invitationHandler(true, self.session)
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
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 60)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}

extension MCServiceManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
		
		let peers = session.connectedPeers.map { $0.displayName }
		
		DispatchQueue.main.async {
			self.connectedPeers = peers
		}
		self.delegate?.onConnectedPeersChanged(manager: self, connectedPeers:
			peers)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
		do {
			let message = try JSONDecoder().decode(Message.self, from: data)
			
			DispatchQueue.main.async {
				self.receivedMessages.append(message)
			}
			self.delegate?.onNewMessageReceived(manager: self, message: message)
			
		} catch let error {
			print("MCServiceManager, Decoding received message error \(error)")
		}
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}


//----

struct MCPeerBrowserViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = MCBrowserViewController

	// identifies each user uniquely in a session
	private let serviceManager: MCServiceManager

	init(serviceManager: MCServiceManager) {
		self.serviceManager = serviceManager
	}

	class Coordinator: NSObject, MCBrowserViewControllerDelegate {
		var parent: MCPeerBrowserViewController

		init(_ parent: MCPeerBrowserViewController) {
			self.parent = parent
		}

		// MCBrowserViewControllerDelegate methods
		func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
			browserViewController.dismiss(animated: true)
		}

		func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
			browserViewController.dismiss(animated: true)
		}
	}

	// UIViewControllerRepresentable Delegates
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}

	func makeUIViewController(context: Context) -> MCBrowserViewController {
	   let mcBrowser = MCBrowserViewController(
		serviceType: MCServiceManager.ServiceType.name,
		session: serviceManager.session
	   )

		mcBrowser.delegate = context.coordinator
		return mcBrowser
	}

	func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {
	}
}
