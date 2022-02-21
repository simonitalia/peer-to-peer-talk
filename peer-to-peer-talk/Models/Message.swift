//
//  Message.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import Foundation

struct Message: Hashable, Identifiable, Codable {
	var id = UUID()
    let content: String
    let author: User
    var isReceived: Bool //for testing with fake data source
	
	init(text content: String, user author: User, isReceived: Bool = false) {
		self.content = content
		self.author = author
		self.isReceived = isReceived
	}
}
