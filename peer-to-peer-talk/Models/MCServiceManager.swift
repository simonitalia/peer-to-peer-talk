//
//  Coordinator.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 09/02/22.
//

import MultipeerConnectivity
import SwiftUI
import UIKit

class MCServiceManager: NSObject, ObservableObject {
	
	enum ServiceType {
		static let name = "peerToPeerTalk"
	}
    
    private(set) var isPeerInvitationAccepted: Bool = false
	
    @Published private(set) var didReceiveInvitationFromPeer: MCPeerID? = nil
    @Published private(set) var didReceiveInvitationFromPeerHandler: ((Bool, MCSession?) -> Void)!
    
    
	@Published private(set) var connectedPeers = [String]()
	@Published private(set) var receivedMessages = [Message]()
	
	private let peerId: MCPeerID
    let session: MCSession
    let advertiser: MCNearbyServiceAdvertiser
    
    init(user: User) {
		self.peerId = MCPeerID(displayName: user.name)
//        self._isPeerInvitationAccepted = peerInvitationAccepted
        
        self.session = MCSession(
            peer: self.peerId,
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

    func send(message: Message) {
        if session.connectedPeers.count > 0 {
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
        
        onReceiveInvitation(from: peerID)
        
        self.didReceiveInvitationFromPeerHandler = invitationHandler
        
        if isPeerInvitationAccepted {
            invitationHandler(true, session)
        }
        
        if !isPeerInvitationAccepted {
            invitationHandler(false, session)
            didReceiveInvitationFromPeer = nil
        }
        
        
    
//        if !isPeerInvitationAccepted { didReceiveInvitationFromPeer = nil }
    }
    
    private func onReceiveInvitation(from peerID: MCPeerID) {
        guard self.didReceiveInvitationFromPeer == nil else { return }
        self.didReceiveInvitationFromPeer = peerID
    }
}

extension MCServiceManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        guard isPeerInvitationAccepted else { return }
		print("MCServiceManager.sesson peer \(peerID) didChangeState: \(state.rawValue)\nconnected peers \(session.connectedPeers.count)")
		
        let peers = session.connectedPeers.map { $0.displayName }
		DispatchQueue.main.async { [unowned self] in
			self.connectedPeers = peers
		}
    }
    
    // Data Received from peers
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        
    }
    
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
        self.onPresentUIViewController()
	}
    
	class Coordinator: NSObject, MCBrowserViewControllerDelegate {
		private var parent: MCPeerBrowserViewController

		init(_ parent: MCPeerBrowserViewController) {
			self.parent = parent
		}

		// MCBrowserViewControllerDelegate methods
		func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
            parent.onDismissUIViewController()
		}

		func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            parent.onDismissUIViewController()
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

	func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {
	}
    
    private func onPresentUIViewController() {
        serviceManager.advertiser.startAdvertisingPeer()
    }
    
    private func onDismissUIViewController() {
        isPresented.toggle()
        serviceManager.advertiser.stopAdvertisingPeer()
    }
}


//struct MCAdvertiserAssistantUIAlertController: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIAlertController
//
//    @Binding var isPresented: Bool
//    private let serviceManager: MCServiceManager
//    var advertiserAssistant: MCAdvertiserAssistant
//
//    init(serviceManager: MCServiceManager, isPresented: Binding<Bool>) {
//        self.serviceManager = serviceManager
//        self._isPresented = isPresented
//
//        self.advertiserAssistant = MCAdvertiserAssistant(
//            serviceType: MCServiceManager.ServiceType.name,
//            discoveryInfo: nil,
//            session: serviceManager.session
//        )
//
//    }
//
//    class Coordinator: NSObject, MCAdvertiserAssistantDelegate {
//        private var parent: MCAdvertiserAssistantUIAlertController
//
//        init(_ parent: MCAdvertiserAssistantUIAlertController) {
//            self.parent = parent
//        }
//
//        func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
//            print("MCServiceManager.advertiserAssistantWillPresentInvitation")
//        }
//
//        func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
//            print("MCServiceManager.advertiserAssistantDidDismissInvitation")
//        }
//    }
//
//    func makeUIViewController(context: Context) -> UIAlertController {
//
//
//
//
//
//
//    }
//
//    func updateUIViewController(_ uiViewController: UIAlertController, context: Context) {
//
//    }
//
//    func makeCoordinator() -> MCAdvertiserAssistantUIAlertController.Coordinator {
//        return Coordinator(self)
//    }
//}
