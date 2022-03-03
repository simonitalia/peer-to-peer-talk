//
//  MainView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI

struct MainView: View {
    @AppStorage("languageIdentifier") private var languageIdentifier = "en"
	@EnvironmentObject var user: User
	@StateObject var mcServiceManager: MCServiceManager
    
	@State private var selectedTabViewItem = 0
	@State private var presentOnboardingView: Bool = false

    var body: some View {
		
		ZStack {
			if user.hasCompletedOnboarding {
		
				TabView(selection: $selectedTabViewItem) {
					ChatView()
						.tabItem {
							Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
						}
						.tag(0)
					
                    SettingsView()
						.tabItem {
							Label("Settings", systemImage: "gear.circle.fill")
						}
						.tag(1)
				}
            
            } else {
                OnboardingView(isPresented: $presentOnboardingView)
            }
		}
		.onAppear {
			presentOnboardingView = !user.hasCompletedOnboarding
		}
        .environmentObject(mcServiceManager)
        .environment(\.locale, .init(identifier: self.languageIdentifier))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
		MainView(
            mcServiceManager: MCServiceManager(
                user: User.sampleUser
            )
        ).environmentObject(User.sampleUser)
        
    }
}
