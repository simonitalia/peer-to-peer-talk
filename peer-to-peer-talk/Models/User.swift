//
//  User.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import SwiftUI

class User: Hashable, Equatable, ObservableObject, Codable {

	let name: String
	var deviceName = UIDevice.current.name
	@Published var hasCompletedOnboarding = false
	
	init () {
		self.name = String().random()
	}
	
	// Hashable conformance
	func hash(into hasher: inout Hasher) {
		hasher.combine(name)
	}
	
	//Equatable conformance
	static func == (lhs: User, rhs: User) -> Bool {
		return lhs.name == rhs.name
	}
	
	//Codable conformance
	enum CodingKeys: CodingKey {
			case name, deviceName, isCurrentUser, hasCompletedOnboarding
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decode(String.self, forKey: .name)
		self.deviceName = try container.decode(String.self, forKey: .deviceName)
		self.hasCompletedOnboarding = try container.decode(Bool.self, forKey: .hasCompletedOnboarding)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.name, forKey: .name)
		try container.encodeIfPresent(self.deviceName, forKey: .deviceName)
		try container.encodeIfPresent(self.hasCompletedOnboarding, forKey: .hasCompletedOnboarding)
	}
	
	class func getUser() -> User {
		return User()
	}
}
