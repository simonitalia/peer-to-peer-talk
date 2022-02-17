//
//  TextBubbleView.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 15/02/22.
//

import SwiftUI

struct TextBubbleView: View {

    var currentMessage: Message
    
    
    var body: some View {
        VStack {
            Text(currentMessage.content)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .padding(.all)
                .background(currentMessage.user.isCurrentUser ? Color("currentUserBubbleColor") : Color("BubbleColor"))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .padding(.all)
    }
}


struct TextBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        TextBubbleView(currentMessage: DataSource.messages[0])
    }
}


