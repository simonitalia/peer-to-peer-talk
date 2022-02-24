//
//  PeopleView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI

struct PeerBrowserView: View {
	@EnvironmentObject var user: User
	@EnvironmentObject var mcServiceManager: MCServiceManager
    
    @State private var isPresententingMCBrowserViewController: Bool = false
	
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
                        
                        //disconnet from current session
                        mcServiceManager.session.disconnect()
                    }
                }
            }
            .onAppear {
                if mcServiceManager.session.connectedPeers.isEmpty {
                    isPresententingMCBrowserViewController.toggle()
            }
        }
        .sheet(isPresented: $isPresententingMCBrowserViewController) {
            MCPeerBrowserViewController(
                         serviceManager: mcServiceManager,
                         isPresented: $isPresententingMCBrowserViewController)
                .interactiveDismissDisabled() //prevent swipe to dismiss
        }
        
    }
}

struct PeerBrowserView_Previews: PreviewProvider {
    static var previews: some View {
		PeerBrowserView()
			.environmentObject(User())
			.environmentObject(MCServiceManager(user: User()))
    }
}
