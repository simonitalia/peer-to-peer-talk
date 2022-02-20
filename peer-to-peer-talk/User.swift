//
//  User.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import SwiftUI

class User: Hashable, Equatable, ObservableObject {

	let name: String
	let deviceName = UIDevice.current.name
	let isCurrentUser: Bool
	@Published var hasCompletedOnboarding = false
	
	init (isCurrentUser: Bool = false) {
		self.name = String().random()
		self.isCurrentUser = isCurrentUser
	}
	
	// Hashable protocol conformance
	func hash(into hasher: inout Hasher) {
		hasher.combine(name)
	}
	
	//Equatable protocol conformance
	static func == (lhs: User, rhs: User) -> Bool {
		return lhs.name == rhs.name
	}
}


struct DataSource {
    static let firstUser = User()
    static var secondUser = User(isCurrentUser: true)
    static let messages = [
        Message(content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", user: DataSource.firstUser, isReceived: true),
        Message(content: "Lacus luctus accumsan tortor posuere ac ut consequat.", user: DataSource.secondUser, isReceived: true),
        Message(content: "😇", user: DataSource.firstUser, isReceived: true),
        Message(content: "Vitae tortor condimentum lacinia quis vel eros donec ac.", user: DataSource.firstUser, isReceived: true),
        Message(content: "Aliquam sem et tortor consequat id porta nibh venenatis.", user: DataSource.secondUser, isReceived: true),
        Message(content: "Ante in nibh mauris cursus mattis molestie a.", user: DataSource.firstUser, isReceived: true),
        
        Message(content: "😇", user: DataSource.firstUser, isReceived: true),
        Message(content: "Vitae tortor condimentum lacinia quis vel eros donec ac.", user: DataSource.firstUser, isReceived: true),
        Message(content: "Aliquam sem et tortor consequat id porta nibh venenatis.", user: DataSource.secondUser, isReceived: true),
        Message(content: "Ante in nibh mauris cursus mattis molestie a.", user: DataSource.firstUser, isReceived: true)
    ]
}
