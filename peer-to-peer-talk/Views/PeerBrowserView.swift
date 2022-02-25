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
                    mcServiceManager.session.disconnect()
                }
            }
        }
        
        .onAppear {
            if mcServiceManager.session.connectedPeers.isEmpty {
                isPresententingMCBrowserViewController.toggle()
            }
        }
        .onChange(of: mcServiceManager.didReceiveInvitationFromPeer) { newValue in
            if newValue != nil {
                isPresentingInvitationFromPeerAlert.toggle()
            }
        }
        
        // present peer browser view controller
        .sheet(isPresented: $isPresententingMCBrowserViewController) {
            MCPeerBrowserViewController(
                         serviceManager: mcServiceManager,
                         isPresented: $isPresententingMCBrowserViewController
            ).interactiveDismissDisabled() //prevent swipe to dismiss
            
            // present invitation to chat alert
            .alert("Invitation Received", isPresented: $isPresentingInvitationFromPeerAlert) {
                Button("Decline", role: .cancel) {
//                    mcServiceManager.isPeerInvitationAccepted = false
                    
                    mcServiceManager.didReceiveInvitationFromPeerHandler(false, mcServiceManager.session)
//                    mcServiceManager.isPeerInvitationAccepted = false
//                    isPresentingInvitationFromPeerAlert.toggle()
                
                }
                Button("Accept") {
//                    mcServiceManager.isPeerInvitationAccepted = true
                    
                    mcServiceManager.didReceiveInvitationFromPeerHandler(true, mcServiceManager.session)
//                    mcServiceManager.isPeerInvitationAccepted = true
//                    isPresentingInvitationFromPeerAlert.toggle()
                }
            }
        }
    }
}

struct PeerBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User.getUser()
		PeerBrowserView()
            .environmentObject(user)
			.environmentObject(
                MCServiceManager(
                    user: user
                )
            )
    }
}

extension PeerBrowserView {}
