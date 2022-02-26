//
//  OnboardingView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/20/22.
//

import SwiftUI

struct OnboardingView: View {
	@EnvironmentObject var user: User
	@Binding var isPresented: Bool
	
	@State private var isShowingOnboardingFirst = true
	
	private var title: String {
		return isShowingOnboardingFirst ? "Welcome to P2P Talk" : "Confirm Display Name"
	}
	
	var body: some View {
	
		NavigationView {
			
			ZStack {
				
				// Select Languag onboarding container
				VStack(alignment: .center) {
					Text("Open settings to change your language")
						.font(Font.system(.title3, design: .rounded).weight(.regular))
						.frame(width: 200, height: 100, alignment: .center)
						.multilineTextAlignment(.center)
						.offset(x: 0, y: -160)
					
					//App settings button
					Button(action: {
						UIApplication.shared.open(
							URL(
							string: UIApplication.openSettingsURLString)!,
							options: [:],
							completionHandler: nil)
									}
					) {
						HStack{
							Image(systemName: "gear")
								.foregroundColor(Color.black)
							Text("App Settings")
								.foregroundColor(Color.black)
						}

					}
					.buttonStyle(BigPaddedButtonStyle2())
					.offset(x: 0, y: -60)
					.shadow(color: .black, radius: 3, x: 3, y: 3)
						
					
					//continue button
					Button(action: {
						isShowingOnboardingFirst = false
					}) {
						Text("Continue")
					}
					.buttonStyle(BigPaddedButtonStyle())
				}
				.opacity(isShowingOnboardingFirst ? 1 : 0)
			
				//Display Name onboarding container
				VStack {
					Text("This name is unchangeble")
						.font(Font.system(.title3, design: .rounded).weight(.regular))
						.frame(width: 200, height: 100, alignment: .center)
						.multilineTextAlignment(.center)
						.offset(x: 0, y: -200)
										
					Text(user.name)
						.foregroundColor(.white)
						.padding()
						.background(Color.gray)
						.offset(x: 0, y: -100)
					
					//continue button
					Button(action: {
						user.hasCompletedOnboarding.toggle()
					}) {
						Text("Continue")
					}
					.buttonStyle(BigPaddedButtonStyle())
					
					VStack {
						Text("Display name will be generated each time you open the app.")
							.padding()
							.multilineTextAlignment(.center)
							.frame(width: 430, height: 130)
							.offset(x: 0, y: 40)
					}
				}
				.opacity(isShowingOnboardingFirst ? 0 : 1)
				
			}
			.navigationTitle(title)
		}
		
		.onChange(of: user.hasCompletedOnboarding) { newValue in
			if newValue {
				isPresented = !newValue
			}
		}
	}
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true)).environmentObject(User.getUser())
    }
}
