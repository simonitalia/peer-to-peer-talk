//
//  PeopleView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI

struct PeerBrowserView: View {
	@EnvironmentObject var user: User
	@StateObject var mcServiceManager: MCServiceManager

    var body: some View {
		NavigationView {
			ZStack {
				Text("PeopleView")
			}
			.navigationTitle("People Nearby")
		}
    }
}

struct PeerBrowserView_Previews: PreviewProvider {
    static var previews: some View {
		PeerBrowserView(mcServiceManager: MCServiceManager(user: User())).environmentObject(User())
    }
}
