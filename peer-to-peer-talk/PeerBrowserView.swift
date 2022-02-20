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
	
	@State var isShowingOnboardingView = false
	
    var body: some View {
		NavigationView {
			ZStack {
				Text("PeopleView")
			}
			.navigationTitle("People Nearby")
			
			.onAppear {
				isShowingOnboardingView = user.hasCompletedOnboarding == false
			}
			
			.fullScreenCover(isPresented: $isShowingOnboardingView) {
				OnboardingView().environmentObject(user)
			}
		}
    }
}

struct PeerBrowserView_Previews: PreviewProvider {
    static var previews: some View {
		PeerBrowserView(mcServiceManager: MCServiceManager(user: User())).environmentObject(User())
    }
}
