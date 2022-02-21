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
	
    @ObservedObject private var keyboard = KeyboardResponder()
	
	@State private var chatThread = [Message]()
	@State private var typedText = ""
	
	@State var chatHelper = ChatHelper() // for testing with fake data

    var body: some View {
		
		NavigationView {
			ScrollViewReader { proxy in
				VStack {
					List {
//						ForEach(chatHelper.realTimeMessages) { message in
						ForEach(chatThread) { message in
							TextBubbleView(user: user, message: message)
						}
					}
					
					Spacer()
					
					HStack {
						TextField("Type something", text: $typedText)
							.font(.system(size: 15, weight: .regular))
							.padding(.all, 15)
							.textFieldStyle(.roundedBorder)
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
				
				.onAppear {
//					proxy.scrollTo(chatHelper.realTimeMessages.last)
					proxy.scrollTo(chatThread.last)
				}
				
				// upddate local data source with received message
				.onChange(of: mcServiceManager.receivedMessages) { _ in
					if let message = mcServiceManager.receivedMessages.last {
						self.chatThread.append(message)
					}
				}
				
				.onChange(of: chatThread) { _ in
					proxy.scrollTo(chatThread.last)
				}
				
			}
			.edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading : .bottom)
		}
    }
    
	func sendMessage() {
		guard !typedText.isEmpty else { return }
		
//		let newMessage = Message(content: typingMessage, user: DataSource.secondUser, isReceived: false)
//		chatHelper.sendMessage(newMessage)
		
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
