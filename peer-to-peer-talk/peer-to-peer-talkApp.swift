//
//  peer_to_peer_talkApp.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 08/02/22.
//

import SwiftUI

@main
struct peer_to_peer_talkApp: App {
	@StateObject var mcServiceManager = MCServiceManager()
	
    var body: some Scene {
        WindowGroup {
			MainView().environmentObject(mcServiceManager)
        }
    }
}
