//
//  ChooseLanguageView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 05/03/22.
//

import SwiftUI

struct ChooseLanguageView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var user: User
    
    @State private var selectedLanguage = User.Language.english

    enum DoneButtonType: String {
        case done = "Done",
             `continue` = "continue"
    }

    let showDoneButton: Bool
    
    var body: some View {
        VStack {
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
                    setLanguage(to: language.rawValue)
                    DataManager.shared.update(user: user)
                }
                
                StaticRadioWaveView()
            }
            
            if showDoneButton {
                Button(LocalizedStringKey(DoneButtonType.done.rawValue)) {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(P2PTalkButtonStyle())
            }
            
        }
        .onAppear {
            setLanguage(to: user.language)
        }
        .environment(\.locale, .init(identifier: user.language))
    }
    
    // set picker selection to user's set language
    func setLanguage(to language: User.Language.RawValue) {
        user.language = language
        
        switch language {
        case User.Language.english.rawValue:
            selectedLanguage = .english
            
        case User.Language.russian.rawValue:
            selectedLanguage = .russian
            
        default:
            return
        }
    }
}

struct ChooseLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLanguageView(
            showDoneButton: true
        ).environmentObject(User.sampleUser)
    }
}
