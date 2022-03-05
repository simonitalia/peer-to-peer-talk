//
//  SettingsView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI

struct SettingsView: View {
@EnvironmentObject var user: User
    
    @State var isPresentingPrivacyPolicy = false
    @State var isPresentingChooseLanguageView = false
    
    var body: some View {
        NavigationView {
            
            List {
                Section(LocalizedStringKey("Display name")) {
                    Label(user.name, systemImage: "person")
                }
                
                Section(LocalizedStringKey("Language")) {
                    Label(user.language, systemImage: "globe.europe.africa")
                        .onTapGesture {
                            isPresentingChooseLanguageView.toggle()
                        }
                }
                
                Section(
                    header: Text(LocalizedStringKey("Privacy")),
                    footer: Text(LocalizedStringKey("P2P Talk requires Local Network access to function."))
                ) {
                    Label(LocalizedStringKey("Privacy Policy"), systemImage: "hand.raised")
                        .onTapGesture {
                            isPresentingPrivacyPolicy.toggle()
                        }
                    
                    Label(LocalizedStringKey("Local Network Access"), systemImage: "network")
                        .onTapGesture {
                            
                        }
                }
                
            }
            .menuIndicator(.automatic)
            .navigationTitle(LocalizedStringKey("Settings"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .environment(\.locale, .init(identifier: user.language))
        
        // show privacy policy
        .sheet(isPresented: $isPresentingPrivacyPolicy) {
            PrivacyPolicyView(
                isPresented: $isPresentingPrivacyPolicy,
                toolbarButtonType: PrivacyPolicyView.ToolbarButtonType.close
            )
        }
        
        // show choose language View
        .sheet(isPresented: $isPresentingChooseLanguageView) {
            ChooseLanguageView(showDoneButton: true)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(User.sampleUser)
    }
}
