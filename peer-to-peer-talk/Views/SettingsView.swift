//
//  SettingsView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI

struct SettingsView: View {
    var languages = ["English", "Russian"]
    @State private var selectedLanguage = "English"
    @AppStorage("languageIdentifier") private var languageIdentifier = "en"
    
    var body: some View {
		NavigationView {
            VStack {
                Picker("Please choose the language", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) {
                        Text(LocalizedStringKey($0))
                    }
                }
                Button {
                    if selectedLanguage == "English" {
                        self.languageIdentifier = "en"
                        
                    } else {
                        self.languageIdentifier = "ru"
                    }
                    
                } label: {
                    Text("Select")
                }
            }
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
