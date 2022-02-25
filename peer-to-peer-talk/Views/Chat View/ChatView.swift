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
    
    
    @State private var chatThread = [Message]()
    @State private var typedText = ""
    
    
    
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
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.white)
                        
                        
                    }
                    
                    Spacer()
                    
                    HStack {
                        TextField("Type something", text: $typedText)
                            .font(.system(size: 15, weight: .regular))
                            .padding(.all, 15)
                            .textFieldStyle(.roundedBorder)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                            .onSubmit {
                                self.sendMessage()
                            }
                        
                        Button {
                            self.sendMessage()
                        } label: {
                            Image(systemName: "arrow.up.circle")
                                .font(.system(size: 25, weight: .regular))
                                .foregroundColor(Color.primary)
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
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(User.getUser())
            .environmentObject(MCServiceManager(user: User.getUser()))
    }
}
