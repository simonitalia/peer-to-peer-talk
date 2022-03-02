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
    
    private enum Language: String, CaseIterable {
        case english = "English", russian = "Russian"
        
        enum Identifier: String {
            case en, ru
        }
    }
    
    private enum OnboardingStep: Int, CaseIterable {
        case one = 1, two = 2, completed = 3
    }
            
    @State private var selectedLanguage: Language = .english
    @State private var onboardingStep = OnboardingStep.one
    @AppStorage("languageIdentifier") private var languageIdentifier = Language.Identifier.en
    
    private var title: String {
        switch onboardingStep {
        case .one:
            return "Welcome to P2P Talk"
        case .two:
            return "Display Name"
        case .completed:
            return ""
        }
    }
    
    var body: some View {
        NavigationView {

            TabView {
                
                // MARK: Onboarding Screen: Welcome
                VStack {
                    Spacer()
                    
                    Text("A New Way to connect! \nAnonynmously and Securley")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    Spacer()
                    
                    ZStack {
                        Image("MainTextBubble")
                        Circle()
                            .stroke()
                            .foregroundColor(.gray)
                            .opacity(0.1)
                            .frame(width: 375, height: 375, alignment: .center)
                        Circle()
                            .stroke()
                            .foregroundColor(.gray)
                            .opacity(0.2)
                            .frame(width: 300, height: 300, alignment: .center)
                        Circle()
                            .stroke()
                            .foregroundColor(.gray)
                            .opacity(0.3)
                            .frame(width: 225, height: 225, alignment: .center)
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
            
                // MARK: Onboarding Screen: Select Language
                VStack {
                    Text("Select your preferred language")

                    Picker("Please choose your language", selection: $selectedLanguage) {
                        ForEach(Language.allCases, id: \.self) {
                            Text(LocalizedStringKey($0.rawValue))
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                // MARK: Onboarding Screen: Display Name
                VStack {

                    Text(user.name)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)

                    Text("You can change your display in settings")
                    
             
                }
            }
            // Page Tab View modifiers
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // Navigation modifiers
            .navigationTitle(LocalizedStringKey(title))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: onboardingStep) { newValue in
            if newValue == .completed {
                user.hasCompletedOnboarding.toggle()
                isPresented.toggle()
                DataManager.shared.update(user: user)
            }
        }
    }
    
    private func setLanguage() {
        guard onboardingStep == .one else { return }
        
        switch selectedLanguage {
        case .english:
            self.languageIdentifier = .en
            
        case .russian:
            self.languageIdentifier = .ru
        }
    }
    
    private func nextOnboardingStep() {
        let nextStep = onboardingStep.rawValue + 1
        OnboardingStep.allCases.forEach { step in
            if step.rawValue == nextStep {
                onboardingStep = step
                return
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true)).environmentObject(User.sampleUser)
    }
}
