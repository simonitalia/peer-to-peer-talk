//
//  OnboardingView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/20/22.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var user: User
    
    @State private var pageIndex = 0
    @State private var isOnboardingCompleted = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $pageIndex) {
            
                // MARK: Onboarding Screen: Select Language
                
                VStack {
                    Spacer()
            
                    ChooseLanguageView(showDoneButton: false)
                    
                    Spacer()
                    
                    Button {
                        pageIndex = 1
                    } label: {
                        HStack {
                            Text(LocalizedStringKey("Continue"))
                            Image(systemName: "arrow.forward")
                        }
                    }
                    .buttonStyle(P2PTalkButtonStyle())
                    
                    Spacer()
                }
                .tag(0)
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                // MARK: Onboarding Screen: Display Name
                
                VStack {
                    Spacer()
                
                    Text(LocalizedStringKey("Anonymous display name"))
                        .font(.title2)
                        .padding()
                    
                    Spacer(minLength: 165)
                    
                    ZStack {
                        Text(user.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        RadioWaveView()
                    }
                    
                    Spacer(minLength: 250)
                    
                    Button {
                        isOnboardingCompleted.toggle()
                    } label: {
                        HStack {
                            Text(LocalizedStringKey("Complete"))
                            Image(systemName: "checkmark")
                        }
                    }
                    .buttonStyle(P2PTalkButtonStyle())
                    
                    Spacer()
                }
                .tag(1)
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            // Page Tab View modifiers
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // Navigation modifiers
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationTitle(LocalizedStringKey("P2P Talk"))
            
        }
        .onChange(of: isOnboardingCompleted) { newValue in
            if newValue {
                user.hasCompletedOnboarding.toggle()
                DataManager.shared.update(user: user)
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(User.sampleUser)
    }
}
