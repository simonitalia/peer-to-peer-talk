//
//  MainView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI

struct MainView: View {
	@State var selectedTabViewItem = 0

    var body: some View {
		
		TabView(selection: $selectedTabViewItem) {
			PeopleView()
				.tabItem {
					Label("People", systemImage: "network.badge.shield.half.filled")
				}
				.tag(0)
			
			ChatViewScreen()
				.tabItem {
					Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
				}
				.tag(1)
			
			SettingsView()
				.tabItem {
					Label("Settings", systemImage: "gear.circle.fill")
				}
				.tag(2)
		}
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
		MainView()
    }
}
