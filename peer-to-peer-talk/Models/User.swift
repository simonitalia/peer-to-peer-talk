//
//  User.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import SwiftUI

class User: Hashable, Equatable, ObservableObject, Codable {

    let id: UUID
    let name: String
    let deviceName: String
    @Published var hasCompletedOnboarding: Bool
	
	private init() {
        self.id = UUID()
		self.name = String().random()
        self.deviceName = UIDevice.current.name
        self.hasCompletedOnboarding = false
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
			case id, name, deviceName, hasCompletedOnboarding
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		self.deviceName = try container.decode(String.self, forKey: .deviceName)
		self.hasCompletedOnboarding = try container.decode(Bool.self, forKey: .hasCompletedOnboarding)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
		try container.encode(self.name, forKey: .name)
		try container.encodeIfPresent(self.deviceName, forKey: .deviceName)
		try container.encodeIfPresent(self.hasCompletedOnboarding, forKey: .hasCompletedOnboarding)
	}
    
    // single shared user between app and previews
    static private let sharedUser = User()
    class func getUser() -> User {
        return sharedUser
    }
}
