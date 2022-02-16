//
//  peer_to_peer_talkApp.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 08/02/22.
//

import SwiftUI

@main
struct peer_to_peer_talkApp: App {
    @StateObject var chatHelper = ChatHelper()
    var body: some Scene {
        WindowGroup {
<<<<<<< HEAD:peer-to-peer-talk/peer-to-peer-talkApp.swift
            ChatViewScreen().environmentObject(chatHelper)
=======
//            ContentView()
            OnboardingFirst()
>>>>>>> c1f7ec1 (onboarding screens):peer-to-peer-talk/PeerToPeerTalkApp.swift
        }
    }
}
