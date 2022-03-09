//
//  WelcomeView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 04/03/22.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var user: User
    
    @State private var isPresentingPrivacyPolicy = false
    @State private var presentOnboardingView: Int? = nil
    
    var body: some View {
        NavigationView {
            
            VStack {
                Spacer()
                
                Text(LocalizedStringKey("Welcome to P2P Talk"))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                ZStack {
                    Image("MainTextBubble")
                    StaticRadioWaveView()
                }
                
                Spacer()
                
                NavigationLink(
                    destination: OnboardingView()
                        .environmentObject(user),
                    tag: 1,
                    selection: $presentOnboardingView)
                {
                    Button {
                        if !user.hasAcceptedPrivacyPolicy {
                            isPresentingPrivacyPolicy.toggle()
                        } else {
                            self.presentOnboardingView = 1
                        }
                    } label: {
                        HStack {
                            Text(user.hasAcceptedPrivacyPolicy ? LocalizedStringKey("Continue") : LocalizedStringKey("Get Started"))
                            Image(systemName: "arrow.forward")
                        }
                    }
                    .buttonStyle(P2PTalkButtonStyle())
                }
                
                Spacer()
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .sheet(isPresented: $isPresentingPrivacyPolicy) {
            PrivacyPolicyView(
                isPresented: $isPresentingPrivacyPolicy,
                toolbarButtonType: PrivacyPolicyView.ToolbarButtonType.accept
            )
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(User.sampleUser)
    }
}
