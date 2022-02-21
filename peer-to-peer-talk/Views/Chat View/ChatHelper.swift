//
//  ChatHelper.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import Combine

class ChatHelper: ObservableObject {
	var didChange = PassthroughSubject<Void, Never>()
	@Published var realTimeMessages = FakeDataSource.messages

	func sendMessage(_ chatMessage: Message) {
		realTimeMessages.append(chatMessage)
		didChange.send(())
	}
}

struct FakeDataSource {
	static let firstUser = User()
	static var secondUser = User(isCurrentUser: true)
	static let messages = [
		Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", user: FakeDataSource.firstUser),
		Message(text: "Lacus luctus accumsan tortor posuere ac ut consequat.", user: FakeDataSource.secondUser),
		Message(text: "😇", user: FakeDataSource.firstUser, isReceived: true),
		Message(text: "Vitae tortor condimentum lacinia quis vel eros donec ac.", user: FakeDataSource.firstUser),
		Message(text: "Aliquam sem et tortor consequat id porta nibh venenatis.", user: FakeDataSource.secondUser),
		Message(text: "Ante in nibh mauris cursus mattis molestie a.", user: FakeDataSource.firstUser),
		
		Message(text: "😇", user: FakeDataSource.firstUser, isReceived: true),
		Message(text: "Vitae tortor condimentum lacinia quis vel eros donec ac.", user: FakeDataSource.firstUser),
		Message(text: "Aliquam sem et tortor consequat id porta nibh venenatis.", user: FakeDataSource.secondUser),
		Message(text: "Ante in nibh mauris cursus mattis molestie a.", user: FakeDataSource.firstUser)
	]
}
