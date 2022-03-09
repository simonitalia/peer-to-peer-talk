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
    @Binding var isPresententingMCBrowserViewController: Bool
    @State private var isPresentingInvitationFromPeerAlert: Bool = false
    
    // Session Management when peers request to connect
    @State private var receivedInvitationPeerId: MCPeerID?
    @State private var invitationResponseHandler: ((Bool, MCSession?) -> Void)!
    
    var body: some View {
        VStack {
            MCPeerBrowserViewController(
                serviceManager: mcServiceManager,
                isPresented: $isPresententingMCBrowserViewController)
        }
        
        .onAppear {
            mcServiceManager.delegate = self
            
            // set color of invitation alert button to app theme
            UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemIndigo
        }
        
        // present invitation to connect alert
        .alert(isPresented: $isPresentingInvitationFromPeerAlert) {
            
            Alert(
                title: Text("Chat Invitation"),
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


extension PeerBrowserView: MCServiceManagerDelegate {
    func onDidReceiveInvitation(from peerId: MCPeerID, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        receivedInvitationPeerId = peerId
        invitationResponseHandler = invitationHandler
        isPresentingInvitationFromPeerAlert.toggle()
    }
}


struct PeerBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        PeerBrowserView(isPresententingMCBrowserViewController: .constant(false))
            .environmentObject(User.sampleUser)
            .environmentObject(
                MCServiceManager(user: User.sampleUser)
            )
    }
}
