//
//  Message.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import Foundation

struct Message: Hashable {
    var content: String
    var user: User
}
