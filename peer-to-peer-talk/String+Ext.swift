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
}
