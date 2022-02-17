//
//  ContentView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 08/02/22.
//

import SwiftUI

struct ChatViewScreen: View {
    @State private var typingMessage = ""
    @EnvironmentObject var chatHelper: ChatHelper
    @ObservedObject private var keyboard = KeyboardResponder()
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .trailing) {
                List {
                    ForEach(chatHelper.realTimeMessages, id: \.self) { message in
                        TextBubbleView(currentMessage: message)
                    }
                }
                Spacer()
                HStack {
                    TextField("Type something", text: $typingMessage)
                        .font(.system(size: 15, weight: .regular))
                        .padding(.all, 15)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            sendMessage()
                            
                        }
                    
                    Button {
                        sendMessage()
                        
                    } label: {
                        Image(systemName: "arrow.up.circle")
                            .font(.system(size: 25, weight: .regular))
                            .foregroundColor(Color.primary)
                    }
                    
                }
                .padding(.all, 15)
            }
            .navigationBarTitle(Text(DataSource.firstUser.name), displayMode: .inline)
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
        }
    }
    
    
    func sendMessage() {
        chatHelper.sendMessage(Message(content: typingMessage, user: DataSource.secondUser))
        typingMessage = ""
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewScreen()
    }
}
