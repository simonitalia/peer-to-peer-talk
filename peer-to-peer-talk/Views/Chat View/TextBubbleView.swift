//
//  TextBubbleView.swift
//  peer-to-peer-talk
//
//  Created by Анастасия Скорюкова on 15/02/22.
//

import SwiftUI

struct TextBubbleView: View {
	
	var user: User
	var message: Message
    
    var body: some View {
        VStack(alignment: message.author.name != user.name ? .trailing : .leading, spacing: 2) {
            Text(message.author.name)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.black)
            Text(message.content)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.white)
                .padding(.all)
				.background(message.author.name == user.name ? Color("currentUserBubbleColor") : Color("BubbleColor"))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }

        
        .id(message.id)
    }
}

struct TextBubbleView_Previews: PreviewProvider {
    static var previews: some View {
		TextBubbleView(
			user: User.sampleUser,
			message: Message.getSampleMessage()
		)
    }
}



