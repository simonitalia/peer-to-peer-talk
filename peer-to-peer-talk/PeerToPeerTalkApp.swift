//
//  peer_to_peer_talkApp.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 08/02/22.
//

import SwiftUI

@main
struct PeerToPeerTalkApp: App {
    @StateObject var user = DataManager.shared.getUser()
	
    var body: some Scene {
        WindowGroup {
            if !user.hasAcceptedPrivacyPolicy {
                WelcomeView()
                    .environmentObject(user)
                    .environment(\.locale, .init(identifier: user.language))
            
            } else if !user.hasCompletedOnboarding {
                OnboardingView()
                    .environmentObject(user)
                    .environment(\.locale, .init(identifier: user.language))
            } else {
                MainView(
                    mcServiceManager: MCServiceManager(
                        user: user)
                )
                .environmentObject(user)
                .environment(\.locale, .init(identifier: user.language))
            }
        }
    }
}
