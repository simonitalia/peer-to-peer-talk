//
//  PeopleView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI

struct PeopleView: View {
	@EnvironmentObject var mcServiceManager: MCServiceManager
	
    var body: some View {
		NavigationView {
			Text("PeopleView")
		}
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
		PeopleView().environmentObject(MCServiceManager())
    }
}
