//
//  ButtonStyle+Extensions.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 2/20/22.
//

import SwiftUI

struct P2PTalkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: 250, minHeight: 0, maxHeight: 50)
            .background(Constants.Colors.buttonBackgroundColor)
            .foregroundColor(Constants.Colors.buttonSecondaryForegroundColor)
            .cornerRadius(30)
        }
}
