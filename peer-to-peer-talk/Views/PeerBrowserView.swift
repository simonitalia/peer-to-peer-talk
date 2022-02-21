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
	
	@State var presentMCBrowserViewController = false
	
    var body: some View {

		ZStack {
			mcServiceManager.presentMCPeerBrowserViewController(serviceManager: mcServiceManager)
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
