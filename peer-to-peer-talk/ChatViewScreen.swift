//
//  ContentView.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 08/02/22.
//

import SwiftUI

struct ChatViewScreen: View {
    @State private var textValue: String = ""
    @State private var isSubmitted = false
    @State var myMessages: [String] = []
    
    
    var body: some View {
        
        VStack(alignment: .trailing) {
            if isSubmitted == true {
                ForEach(myMessages) { message in
                    TextBubbleView(text: message, bubbleColor: Color("BubbleColor"))
                }
            }
            Spacer()
            HStack {
                TextField("Type something", text: $textValue)
                    .padding(.all, 15)
                    .onSubmit {
                        isSubmitted = true
                        myMessages.append(textValue)
                        textValue = ""
                    }
                
                Button {
                    isSubmitted = true
                    myMessages.append(textValue)
                    textValue = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.primary)
                }
                
            }
        }
        .padding(.all, 15)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewScreen()
    }
}
