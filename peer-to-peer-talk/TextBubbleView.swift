//
//  TextBubbleView.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 15/02/22.
//

import SwiftUI

struct TextBubbleView: View {
    
    var message: Message
    
    var body: some View {
        VStack {
            Text(message.content)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .padding(.all)
                .background(message.user.isCurrentUser ? Color("currentUserBubbleColor") : Color("BubbleColor"))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .frame(maxWidth: .infinity, alignment: message.isReceived ? .leading : .trailing)
        .padding(.all)
        .id(message.id)
    }
}


struct TextBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        TextBubbleView(message: DataSource.messages[0])
    }
}



