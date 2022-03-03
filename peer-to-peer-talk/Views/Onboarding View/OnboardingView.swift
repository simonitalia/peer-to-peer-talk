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
    @AppStorage("languageIdentifier") private var languageIdentifier = Language.Identifier.en
    @State private var selectedLanguage: Language = .english
    private enum Language: String, CaseIterable {
        case english = "English", russian = "Russian"
        
        enum Identifier: String {
            case en, ru
        }
    }
    
    @State private var isOnboardingCompleted = false
    
    var body: some View {
        NavigationView {

            TabView {
                
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
                    
                    HStack(alignment: .center) {
                        Text("Get Started")
                        Text(Image(systemName: "arrow.forward"))
                    }
                    .frame(minWidth: 0, maxWidth: 250, minHeight: 0, maxHeight: 50)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    
                    Spacer()
                }
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
                            ForEach(Language.allCases, id: \.self) {
                                Text(LocalizedStringKey($0.rawValue))
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        StaticRadioWaveView()
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Text("Continue")
                        Text(Image(systemName: "arrow.forward"))
                    }
                    .frame(minWidth: 0, maxWidth: 250, minHeight: 0, maxHeight: 50)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    
                    Spacer()
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                // MARK: Onboarding Screen: Display Name
                VStack {
                    Spacer()
                
                    Text("Your private name shown to others")
                        .font(.title2)
                        .padding()
                    
                    ZStack {
                        Text(user.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        RadioWaveView()
                    }
                    
                    Spacer()
                    
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
    
    private func setLanguage(to language: Language) {
        
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
