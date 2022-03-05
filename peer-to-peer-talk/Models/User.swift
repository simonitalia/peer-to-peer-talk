//
//  User.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import SwiftUI

class User: Hashable, Equatable, ObservableObject, Codable {
    
    enum Language: String, CaseIterable {
        case english = "English",
             russian = "Russian"
    }

    let id: UUID
    let name: String
    @Published var language: Language.RawValue
    @Published var hasCompletedOnboarding: Bool
    @Published var hasAcceptedPrivacyPolicy: Bool
	
	init() {
        self.id = UUID()
		self.name = String().random()
        self.language = Language.english.rawValue
        self.hasCompletedOnboarding = false
        self.hasAcceptedPrivacyPolicy = false
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
        case id,
             name,
             language,
             hasCompletedOnboarding,
             hasAcceptedPrivacyPolicy
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
        self.language = try container.decode(Language.RawValue.self, forKey: .language)
		self.hasCompletedOnboarding = try container.decode(Bool.self, forKey: .hasCompletedOnboarding)
        self.hasAcceptedPrivacyPolicy = try container.decode(Bool.self, forKey: .hasAcceptedPrivacyPolicy)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
		try container.encode(self.name, forKey: .name)
        try container.encode(self.language, forKey: .language)
        try container.encodeIfPresent(self.hasCompletedOnboarding, forKey: .hasCompletedOnboarding)
        try container.encodeIfPresent(self.hasAcceptedPrivacyPolicy, forKey: .hasAcceptedPrivacyPolicy)
	}
    
    // sample user for previews
    static let sampleUser = User()
}
