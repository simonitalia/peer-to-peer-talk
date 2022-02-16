//
//  TextBubbleView.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 15/02/22.
//

import SwiftUI

struct TextBubbleView: View {
    var text: String
    var bubbleColor: Color
    
    var body: some View {
        VStack {
            Text("\(text)")
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(.white)
                .padding(.all)
                .background(Color("BubbleColor"))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .padding(.all)
    }
}


struct TextBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        TextBubbleView(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ", bubbleColor: Color("BubbleColor"))
    }
}


