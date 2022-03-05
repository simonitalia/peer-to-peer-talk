//
//  WelcomeView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 04/03/22.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @EnvironmentObject var user: User
    @Binding var isPresented: Bool
    let toolbarButtonType: ToolbarButtonType
    
    enum ToolbarButtonType: String {
        case accept = "Accept",
             close = "Close"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("P2P Talk Privacy Policy")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text ("Our mission is to give users an opportunity to communicate anonymously and privately.")
                    
                    Text("Information Usage")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("We do not collect any information from devices or share anything with third parties.")
                    
                    Text("Security")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("This application uses Apple’s Multipeer Connectivity framework that allows device find nearby devices with the same app installed. That means this application does not use internet connection and never goes through any servers. Data is transmitted only to a nearby devices. Chat messages are encrypted between devices using Apple Decryption algorithm. Chat history is automatically deleted after the application is closed, so any data is not saved.")
                    
                    Text("Abusive content")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Our team is not responsible for user actions and user behavior. The user himself is responsible for his actions and words that were transmitted using this application.")
                    
                    Text("Online Privacy Policy Updates")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("We may make changes to our Privacy Policy from time to time. Please review our policies regularly as updated policies will apply to your future use of our Services.")
                }
            }
            .padding()
            .navigationTitle("Privacy Policy")
            .toolbar {
                switch toolbarButtonType {
                case.accept:
                    Button(LocalizedStringKey(ToolbarButtonType.accept.rawValue)) {
                        user.hasAcceptedPrivacyPolicy.toggle()
                    }

                case .close:
                    Button(LocalizedStringKey(ToolbarButtonType.close.rawValue)) {
                        isPresented.toggle()
                    }
                }
            }
            .onChange(of: user.hasAcceptedPrivacyPolicy) { newValue in
                if newValue {
                    DataManager.shared.update(user: user)
                    isPresented.toggle()
                }
            }
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView(
            isPresented: .constant(true),
            toolbarButtonType: .accept
        ).environmentObject(User.sampleUser)
    }
}
