//
//  MainView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var user: User
    @StateObject var mcServiceManager: MCServiceManager
    
	@State private var selectedTabViewItem = 0

    var body: some View {
		
		ZStack {
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
		}
        .environmentObject(mcServiceManager)
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
