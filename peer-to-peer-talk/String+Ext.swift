//
//  String+Ext.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 15/02/22.
//

import Foundation

extension String: Identifiable {
    public typealias ID = Int
    
    public var id: Int {
        return hash
    }
	
	func random() -> String {
		let base = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		var randomString: String = ""
		let length = 6

		for _ in 0..<length {
			let randomValue = arc4random_uniform(UInt32(base.count))
			randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
		}
		
		return randomString
	}
}
