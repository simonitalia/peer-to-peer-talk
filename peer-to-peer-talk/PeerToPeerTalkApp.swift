//
//  peer_to_peer_talkApp.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 08/02/22.
//

import SwiftUI

@main
struct PeerToPeerTalkApp: App {
	@StateObject var user = User.getUser()
	
    var body: some Scene {
        WindowGroup {
			MainView(mcServiceManager: MCServiceManager(user: user))
				.environmentObject(user)
        }
    }
}
