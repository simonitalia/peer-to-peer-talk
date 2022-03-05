//
//  OnboardingView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/20/22.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var user: User
    
    @State private var selectedLanguage = User.Language.english
    @State private var pageIndex = 0
    @State private var isOnboardingCompleted = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $pageIndex) {
            
                // MARK: Onboarding Screen: Select Language
                
                VStack {
                    Spacer()
                    
                    Text(LocalizedStringKey("Set language"))
                        .font(.title2)
                        .padding()
                    
                    ZStack {
                        Picker(LocalizedStringKey("Please choose your language"), selection: $selectedLanguage) {
                            ForEach(User.Language.allCases, id: \.self) {
                                Text(LocalizedStringKey($0.rawValue))
                            }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: selectedLanguage) { language in
                            user.language = language.rawValue
                            DataManager.shared.update(user: user)
                        }
                        
                        StaticRadioWaveView()
                    }
                    
                    Spacer()
                    
                    Button {
                        pageIndex = 1
                    } label: {
                        Text(LocalizedStringKey("Continue"))
                        Image(systemName: "arrow.forward")
                    }
                    .frame(minWidth: 0, maxWidth: 250, minHeight: 0, maxHeight: 50)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    
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
                        Text(LocalizedStringKey("Complete"))
                        Image(systemName: "checkmark")
                    }
                    .frame(minWidth: 0, maxWidth: 250, minHeight: 0, maxHeight: 50)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    
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
        
        // set picker selection to user's set language
        .onAppear {
            switch user.language {
            case User.Language.english.rawValue:
                selectedLanguage = .english
            case User.Language.russian.rawValue:
                selectedLanguage = .russian
            default:
                return
            }
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
