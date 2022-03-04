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
    
    // Language properties
    @AppStorage("languageIdentifier") private var languageIdentifier = MainView.Language.Identifier.en
    @State private var selectedLanguage: MainView.Language = .english
    @State private var isOnboardingCompleted = false
    @State private var pageIndex = 0
    
    var body: some View {
        NavigationView {

            TabView(selection: $pageIndex) {
                
                // MARK: Onboarding Screen: Welcome
                VStack {
                    Spacer()
                    
                    Text("Welcome to P2P Talk")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    ZStack {
                        Image("MainTextBubble")
                        StaticRadioWaveView()
                    }
                    
                    Spacer()
                    
                    Button {
                        pageIndex = 1
                    } label: {
                        Text("Get Started")
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
            
                // MARK: Onboarding Screen: Select Language
                VStack {
                    Spacer()
                    
                    Text("Set preferred language")
                        .font(.title2)
                        .padding()
                    
                    ZStack {
                        Picker("Please choose your language", selection: $selectedLanguage) {
                            ForEach(MainView.Language.allCases, id: \.self) {
                                Text(LocalizedStringKey($0.rawValue))
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        StaticRadioWaveView()
                    }
                    
                    Spacer()
                    
                    Button {
                        pageIndex = 2
                    } label: {
                        Text("Continue")
                        Image(systemName: "arrow.forward")
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
                
                // MARK: Onboarding Screen: Display Name
                VStack {
                    Spacer()
                
                    Text("Your private name shown to others")
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
                        Text("Complete")
                        Image(systemName: "checkmark")
                    }
                    .frame(minWidth: 0, maxWidth: 250, minHeight: 0, maxHeight: 50)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    
                    Spacer()
                }
                .tag(2)
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            // Page Tab View modifiers
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // Navigation modifiers
            .navigationTitle(LocalizedStringKey("P2P Talk"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: selectedLanguage) { language in
            setLanguage(to: language)
        }
        .onChange(of: isOnboardingCompleted) { newValue in
            if newValue {
                user.hasCompletedOnboarding.toggle()
                isPresented.toggle()
                DataManager.shared.update(user: user)
            }
        }
    }
    
    private func setLanguage(to language: MainView.Language) {
        
        switch language {
        case .english:
            self.languageIdentifier = .en

        case .russian:
            self.languageIdentifier = .ru
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true)).environmentObject(User.sampleUser)
    }
}
