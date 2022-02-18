//
//  User.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 17/02/22.
//

import Foundation

struct User: Hashable {
    var name: String
    var isCurrentUser = false
}


struct DataSource {
    static let firstUser = User(name: "Alice")
    static var secondUser = User(name: "Mary", isCurrentUser: true)
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
