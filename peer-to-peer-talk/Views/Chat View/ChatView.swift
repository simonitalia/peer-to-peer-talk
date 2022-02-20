//
//  ContentView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 08/02/22.
//

import SwiftUI

struct ChatView: View {
    @State private var typingMessage = ""
    @State var chatHelper = ChatHelper()
    @ObservedObject private var keyboard = KeyboardResponder()

    var body: some View {
		
		NavigationView {
			ScrollViewReader { proxy in
				VStack {
					List {
						ForEach(chatHelper.realTimeMessages) { message in
							TextBubbleView(message: message)
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
				.onAppear {
					proxy.scrollTo(chatHelper.realTimeMessages.last)
				}
				
			}
			.edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading : .bottom)
		}
    }
    
    func sendMessage() {
        let newMessage = Message(content: typingMessage, user: DataSource.secondUser, isReceived: false)
        chatHelper.sendMessage(newMessage)
        typingMessage = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
