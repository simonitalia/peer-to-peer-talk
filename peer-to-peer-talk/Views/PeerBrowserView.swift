//
//  PeopleView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI
import MultipeerConnectivity

struct PeerBrowserView: View {
	@EnvironmentObject var user: User
	@EnvironmentObject var mcServiceManager: MCServiceManager
    
    @State private var isPresententingMCBrowserViewController: Bool = false
    @State private var isPresentingInvitationFromPeerAlert: Bool = false
    
    // Session Management when peers request to connect
    @State private var receivedInvitationPeerId: MCPeerID?
    @State private var invitationResponseHandler: ((Bool, MCSession?) -> Void)!
    
    var body: some View {
        NavigationView {
            ZStack {
                Text("PeerBrowser")
            }
            
            // Navigation
            .navigationTitle("Display Name: \(user.name)")
            .toolbar {
                Button("Start New Chat") {
                    isPresententingMCBrowserViewController.toggle()
                }
            }
        }
        
        .onAppear {
            mcServiceManager.delegate = self
                // to be notified of invitation requests
            if mcServiceManager.session.connectedPeers.isEmpty {
                isPresententingMCBrowserViewController.toggle()
            }
        }
        
        // present peer browser view controller
        .sheet(isPresented: $isPresententingMCBrowserViewController) {
            MCPeerBrowserViewController(
                serviceManager: mcServiceManager,
                isPresented: $isPresententingMCBrowserViewController
            ).interactiveDismissDisabled() //prevent swipe to dismiss
            
            // present invitation to connect alert
                .alert(isPresented: $isPresentingInvitationFromPeerAlert) {
                    
                    Alert(
                        title: Text("New Invitation"),
                        message: Text("\(receivedInvitationPeerId!.displayName) would like to connect"),
                        primaryButton: .destructive(Text("Decline")) {
                            invitationResponseHandler(false, nil)
                        },
                        secondaryButton: .default(Text("Accept")) {
                            invitationResponseHandler(true, mcServiceManager.session)
                        }
                    )
                }
        }
    }
}

extension PeerBrowserView: MCServiceManagerDelegate {
    func onDidReceiveInvitation(from peerId: MCPeerID, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        receivedInvitationPeerId = peerId
        invitationResponseHandler = invitationHandler
        isPresentingInvitationFromPeerAlert.toggle()
    }
}

struct PeerBrowserView_Previews: PreviewProvider {
    static var previews: some View {
		PeerBrowserView()
            .environmentObject(User.sampleUser)
			.environmentObject(
                MCServiceManager(user: User.sampleUser)
            )
    }
}
