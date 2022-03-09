//
//  ContentView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 08/02/22.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var mcServiceManager: MCServiceManager
    @State private var isPresententingPeerBrowserView: Bool = true
    @State private var chatThread = [Message]()
    @State private var typedText = ""
    @State private var isPresentingAlert = false
    @State private var navigationTitleText = ""
    
    
    private var navigationTitle: LocalizedStringKey {
        if let title = mcServiceManager.connectedPeers.first?.displayName {
            return LocalizedStringKey("Connected to \(title)") }
        else { return "No peer connected" }
    }
    
    
    private var buttonImageTitle: String {
        return mcServiceManager.connectedPeers.isEmpty ? "square.and.pencil" : "rectangle.portrait.and.arrow.right.fill"
    }
    
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack {
                    List {
                        ForEach(chatThread) { message in
                            TextBubbleView(user: user, message: message)
                                .id(message)
                                .frame(maxWidth: .infinity, alignment: message.author.name != user.name ? .leading : .trailing)
                                .padding([.bottom, .leading, .trailing], 15)
                                .onChange(of: chatThread) { _ in
                                    withAnimation(.easeIn) {
                                        proxy.scrollTo(chatThread.last, anchor: .bottom)
                                    }
                                }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 7) {
                        TextField("Type something", text: $typedText)
                            .font(.system(size: 20, weight: .regular))
                            .padding(.all, 10)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.indigo, style: StrokeStyle(lineWidth: 1.0)))
                        
                            .onSubmit {
                                self.sendMessage()
                            }
                        
                        Button {
                            self.sendMessage()
                        } label: {
                            Image(systemName: "paperplane.circle.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color.indigo)
                        }
                    }
                    .padding(.all, 15)
                }
                
                
                // update local data source with received message
                .onChange(of: mcServiceManager.receivedMessages) { _ in
                    if let message = mcServiceManager.receivedMessages.last {
                        self.chatThread.append(message)
                    }
                }
            }
            
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack {
                        Spacer(minLength: 50)
                        Image(systemName: "circlebadge.fill")
                            .foregroundColor(!mcServiceManager.connectedPeers.isEmpty ? Color.green : Color.gray)
                        Spacer()
                        Text(navigationTitle)
                            .foregroundColor(Color("SecondaryTextColor"))
                        Spacer(minLength: 50)
                    }
                }
                
                ToolbarItem {
                    Button {
                        mcServiceManager.connectedPeers.isEmpty ? resetChatThread() : (self.isPresentingAlert = true)
                    } label: {
                        Image(systemName: buttonImageTitle)
                            .font(.title2)
                        
                    }
                }
            }
        }
        
        
        .alert(isPresented: $isPresentingAlert) {
            Alert(title: Text("Leave Chat"), message: Text("Are you sure you want to leave the chat?"),
                  primaryButton: .default(Text("No")){
            },
                  secondaryButton: .destructive(Text("Yes")) {
                resetChatThread()
            }
            )
        }
        
        
        .sheet(isPresented: $isPresententingPeerBrowserView) {
            PeerBrowserView(isPresententingMCBrowserViewController: $isPresententingPeerBrowserView).interactiveDismissDisabled()
        }
    }
    
    
    func sendMessage() {
        guard !typedText.isEmpty else { return }
        
        let newMessage = Message(
            text: typedText,
            user: user
        )
        
        //update local data source with typed message and send message to peers
        self.chatThread.append(newMessage)
        self.mcServiceManager.send(message: newMessage)
        
        //reset text field
        self.typedText.removeAll()
    }
    
    
    private func resetChatThread() {
        chatThread.removeAll()
        isPresententingPeerBrowserView.toggle()
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(User.sampleUser)
            .environmentObject(MCServiceManager(
                user: User.sampleUser)
            )
    }
}
