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
        VStack(alignment: message.author.name != user.name ? .leading : .trailing, spacing: 3) {
            Text(message.author.name)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color("TertiaryColor"))
            Text(message.content)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(message.author.name == user.name ? Color.white : Color("SecondaryTextColor"))
                .padding(.all)
                .background(message.author.name == user.name ? Color("PrimaryColor") : Color("SecondaryColor"))
                .clipShape(
                    message.author.name == user.name ?
                    ChatRoundedShape(corners: [.topLeft, .bottomLeft, .topRight], radius: 25) :
                        ChatRoundedShape(corners: [.topLeft, .topRight, .bottomRight], radius: 25)
                )
        }
        .id(message.id)
    }
}


struct ChatRoundedShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
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



