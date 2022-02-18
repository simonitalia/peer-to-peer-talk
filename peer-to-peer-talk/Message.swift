//
//  Message.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import Foundation

struct Message: Hashable, Identifiable {
    var content: String
    var user: User
    var isReceived: Bool
    let id = UUID()
}
