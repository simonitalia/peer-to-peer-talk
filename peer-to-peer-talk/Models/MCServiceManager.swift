//
//  Coordinator.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 09/02/22.
//

import MultipeerConnectivity
import SwiftUI
import UIKit

protocol MCServiceManagerDelegate {
    func onDidReceiveInvitation(from peerId: MCPeerID, invitationHandler: @escaping (Bool, MCSession?) -> Void)
}

class MCServiceManager: NSObject, ObservableObject {
	
	enum ServiceType {
		static let name = "peerToPeerTalk"
	}
    
	@Published private(set) var receivedMessages = [Message]()
	
	let peerId: MCPeerID
    private let advertiser: MCNearbyServiceAdvertiser
    let session: MCSession
    
    var delegate: MCServiceManagerDelegate?
    
    init(user: User) {
		self.peerId = MCPeerID(displayName: user.name)

        self.session = MCSession(
            peer: peerId,
            securityIdentity: nil,
            encryptionPreference: .required
        )

        self.advertiser = MCNearbyServiceAdvertiser(
            peer: peerId,
            discoveryInfo: nil,
            serviceType: ServiceType.name
        )
        
        super.init()
        self.session.delegate = self
        self.advertiser.delegate = self
    }

    func onPresentMCPeerBrowserViewController() {
        disconnectFromSession()
        advertiser.startAdvertisingPeer()
    }
    
    func onDismissMCPeerBrowserViewController() {
        advertiser.stopAdvertisingPeer()
    }
    
    func disconnectFromSession() {
        session.disconnect() // ensure no existing sessions
    }
    
    func send(message: Message) {
        if !session.connectedPeers.isEmpty {
            do {
                let data = try JSONEncoder().encode(message)
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)

            } catch let error {
                print("MCServiceManager.send errror: \(error)")
            }
        }
    }
}

extension MCServiceManager: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("MCServiceManager.advertiser didNotStartAdvertisingPeer: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("MCServiceManager.advertiser didReceiveInvitationFromPeer: \(peerID)")
        
        // peer invitation handler
        delegate?.onDidReceiveInvitation(from: peerID, invitationHandler: invitationHandler)
    }
}

extension MCServiceManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("MCServiceManager.session peer \(peerID.displayName) didChangeState: \(state.rawValue)\npeers in session \(session.connectedPeers.count)")
        
        switch state {
            case .connected:
                print("Connected with peer: \(peerID.displayName)")

            case .connecting:
                print("Connecting to peer: \(peerID.displayName)")

            case .notConnected:
                print("Not Connected with peer: \(peerID.displayName)")

            @unknown default:
                print("Unknown state received: \(peerID.displayName)")
            }
    }
    
    // Data Received from peers
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
		do {
			let message = try JSONDecoder().decode(Message.self, from: data)
            DispatchQueue.main.async { [unowned self] in
				self.receivedMessages.append(message)
			}
			
		} catch let error {
			print("MCServiceManager.session didReceive error: \(error)")
		}
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}


// MARK: - Multipeer Connectivity Peer Browser ViewController

struct MCPeerBrowserViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = MCBrowserViewController
    
    @Binding var isPresented: Bool
	private let serviceManager: MCServiceManager

    init(serviceManager: MCServiceManager, isPresented: Binding<Bool>) {
		self.serviceManager = serviceManager
        self._isPresented = isPresented
	}
    
	class Coordinator: NSObject, MCBrowserViewControllerDelegate, MCAdvertiserAssistantDelegate {
		private var parent: MCPeerBrowserViewController

		init(_ parent: MCPeerBrowserViewController) {
			self.parent = parent
            self.parent.serviceManager.onPresentMCPeerBrowserViewController()
		}

		// MCBrowserViewControllerDelegate methods
		func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
            parent.isPresented.toggle()
            parent.serviceManager.onDismissMCPeerBrowserViewController()
		}

		func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            parent.isPresented.toggle()
            parent.serviceManager.disconnectFromSession()
            parent.serviceManager.onDismissMCPeerBrowserViewController()
		}
	}

	// UIViewControllerRepresentable Delegates
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}

    func makeUIViewController(context: Context) -> MCBrowserViewController {
       
	   let vc = MCBrowserViewController(
        serviceType: MCServiceManager.ServiceType.name,
		session: serviceManager.session
	   )
        
		vc.delegate = context.coordinator
		return vc
	}
    
	func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {}
}
