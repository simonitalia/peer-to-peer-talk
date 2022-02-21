//
//  ButtonStyle+Extensions.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/20/22.
//

import SwiftUI

struct BigPaddedButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		let steelGray = Color(white: 0.8)
		return configuration
			.label
			.foregroundColor(configuration.isPressed ? .gray : .black)
			.padding(EdgeInsets(top: 0, leading: 110, bottom: 0, trailing: 110))
			.frame(minWidth: 0, maxWidth: .infinity)
			.padding()
			.background(steelGray)
			.cornerRadius(10)
			.padding(10)
	}
}
