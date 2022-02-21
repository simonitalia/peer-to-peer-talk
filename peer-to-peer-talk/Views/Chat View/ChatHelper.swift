//
//  ChatHelper.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import Foundation
import Combine

class ChatHelper: ObservableObject {
	var didChange = PassthroughSubject<Void, Never>()
	@Published var realTimeMessages = FakeDataSource.messages

	func sendMessage(_ chatMessage: FakeMessage) {
		realTimeMessages.append(chatMessage)
		didChange.send(())
	}
}

struct FakeDataSource {
	static let firstUser = FakeUser(name: "Jack", isCurrentUser: false)
	static var secondUser = FakeUser(name: "Jill", isCurrentUser: true)
	static let messages = [
		FakeMessage(
		content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
			user: FakeDataSource.firstUser,
			isReceived: false),
		
		FakeMessage(
			content: "Lacus luctus accumsan tortor posuere ac ut consequat.",
			user: FakeDataSource.secondUser,
			isReceived: false),
		
		FakeMessage(
			content: "😇",
			user: FakeDataSource.firstUser,
			isReceived: true),
		
		FakeMessage(
			content: "Vitae tortor condimentum lacinia quis vel eros donec ac.",
			user: FakeDataSource.firstUser,
			isReceived: true),
		
		FakeMessage(
			content: "Aliquam sem et tortor consequat id porta nibh venenatis.",
			user: FakeDataSource.secondUser,
			isReceived: false),
		
		FakeMessage(
			content: "Ante in nibh mauris cursus mattis molestie a.",
				user: FakeDataSource.firstUser,
			isReceived: true),
		
		FakeMessage(
			content: "😇",
			user: FakeDataSource.firstUser,
			isReceived: true),
		
		FakeMessage(
			content: "Vitae tortor condimentum lacinia quis vel eros donec ac.",
			user: FakeDataSource.firstUser,
			isReceived: true),
		
		FakeMessage(
			content: "Aliquam sem et tortor consequat id porta nibh venenatis.",
			user: FakeDataSource.secondUser,
			isReceived: false),
		
		FakeMessage(
			content: "Ante in nibh mauris cursus mattis molestie a.",
			user: FakeDataSource.firstUser,
			isReceived: true)
	]
}

struct FakeUser {
	let name: String
	let isCurrentUser: Bool
}

struct FakeMessage: Identifiable {
	var id = UUID()
	let content: String
	let user: FakeUser
	let isReceived: Bool
}
