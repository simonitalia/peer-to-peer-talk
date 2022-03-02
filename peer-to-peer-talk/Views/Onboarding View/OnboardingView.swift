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
            ZStack {
                
                VStack {
                    
                    Spacer()
                    
                    // Select Language onboarding container
                    VStack(alignment: .center) {
                        Text("Select language")
                        
                        Picker("Please choose your language", selection: $selectedLanguage) {
                            ForEach(Language.allCases, id: \.self) {
                                Text(LocalizedStringKey($0.rawValue))
                            }
                        }
                        .pickerStyle(.wheel)
                        .offset(x: 0, y: -20)
                    }
                    .zIndex(0)
                    .opacity(onboardingStep == .one ? 1 : 0)
                    
                    //Display Name onboarding container
                    VStack(alignment: .center) {
                        Text(user.name)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                        
                        Text("You can change your display in settings")
//                            .offset(x: 0, y: -100)
                    }
                    .zIndex(1)
                    .opacity(onboardingStep == .two ? 1 : 0)
                    
                    Spacer()
                        
                    //continue button
                    Button(onboardingStep == .one ? "Continue" : "Complete") {
                        setLanguage()
                        nextOnboardingStep()
                    }
                    .background(Color(UIColor.systemBlue))
                    .foregroundColor(Color(UIColor.white))
                    .cornerRadius(CGFloat(5))
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(LocalizedStringKey(title))
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
