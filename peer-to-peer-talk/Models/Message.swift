//
//  Message.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import Foundation

struct Message: Hashable, Identifiable {
	let id = UUID()
    var content: String
    let user: User
    var isReceived: Bool
}
