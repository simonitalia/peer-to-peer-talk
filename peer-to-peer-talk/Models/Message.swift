//
//  Message.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import Foundation

struct Message: Hashable, Identifiable, Codable {
    let id: UUID
    let content: String
    let author: User
	
	init(text content: String, user author: User) {
        self.id = UUID()
        self.content = content
		self.author = author
	}
	
	static func getSampleMessage() -> Message {
		return Message(
            text: "Sample Text",
            user: User.sampleUser
		)
	}
}
