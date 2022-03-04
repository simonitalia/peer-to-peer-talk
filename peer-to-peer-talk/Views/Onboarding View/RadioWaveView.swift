//
//  RadioWaveView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 02/03/22.
//

import SwiftUI

struct RadioWaveView: View {
    
    @State private var animationAmount = 1.0
    @State private var scaleAmount = 1.0
    
    var body: some View {
        ZStack {
            makeCircleView()
                .stroke(.indigo)
                .scaleEffect(scaleAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeInOut(duration: 1.25)
                        .repeatForever(autoreverses: false),
                    value: animationAmount
                )
                .frame(width: 50, height: 50, alignment: .center)
        }
        .onAppear {
            animationAmount = 2
            scaleAmount = 20
        }
    }
    
    func makeCircleView() -> Circle {
        return Circle()
    }
}

struct RadioWaveView_Previews: PreviewProvider {
    static var previews: some View {
        RadioWaveView()
    }
}


struct StaticRadioWaveView: View {
    
    var body: some View {
        ZStack {
            Circle()
                .stroke()
                .foregroundColor(.indigo)
                .opacity(0.1)
                .frame(width: 375, height: 375, alignment: .center)
            Circle()
                .stroke()
                .foregroundColor(.indigo)
                .opacity(0.2)
                .frame(width: 300, height: 300, alignment: .center)
            Circle()
                .stroke()
                .foregroundColor(.indigo)
                .opacity(0.3)
                .frame(width: 225, height: 225, alignment: .center)
        }
    }
}

struct StaticRadioWaveView_Previews: PreviewProvider {
    static var previews: some View {
        StaticRadioWaveView()
    }
}


