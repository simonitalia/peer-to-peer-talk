//
//  SettingsView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/19/22.
//

import SwiftUI
import Network

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
                
                Section(
                    header: Text(LocalizedStringKey("Language"))
                    ,
                    footer: Text(LocalizedStringKey("Some features of P2P Talk use your device's preferred language."))
                ) {
                    
                    HStack {
                        Label(user.language, systemImage: "globe.europe.africa")
                            .onTapGesture {
                                isPresentingChooseLanguageView.toggle()
                            }
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.indigo)
                    }
                    
                    HStack {
                        Label(Locale.preferredLanguages[0].localizedUppercase, systemImage: "iphone")
                            .onTapGesture {
                                Utils.openSettingsUrl(path: .localNetwork)
                            }
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.indigo)
                    }
                }
                
                Section(
                    header: Text(LocalizedStringKey("Privacy")),
                    footer: Text(LocalizedStringKey("P2P Talk requires Local Network access to function. Please ensure Local Network is enabled."))
                ) {
                    HStack {
                        Label(LocalizedStringKey("Privacy Policy"), systemImage: "hand.raised")
                            .onTapGesture {
                                isPresentingPrivacyPolicy.toggle()
                            }
                        Spacer()
                        Image(systemName: "chevron.forward")
                                .foregroundColor(.indigo)
                    }
                    
                    HStack {
                        Label(LocalizedStringKey("Local Network Access"), systemImage: "network")
                            .onTapGesture {
                                Utils.openSettingsUrl(path: .localNetwork)
                            }
                        Spacer()
                        Image(systemName: "chevron.forward")
                                .foregroundColor(.indigo)
                    }
                }
            }
            .menuIndicator(.automatic)
            .navigationTitle(LocalizedStringKey("Settings"))
            .navigationBarTitleDisplayMode(.inline)
        }

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
        .environment(\.locale, .init(identifier: user.language))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(User.sampleUser)
    }
}
