//
//  OnboardingSecond.swift
//  peer-to-peer-talk
//
//  Created by Глеб Малов on 15/02/22.
//

import SwiftUI

struct OnboardingSecond: View {
    
    
    @State var showingDetail = false

    
    let randomString = UUID().uuidString //Change name; make it a bit shorter
    

    var body: some View {
        
        
        NavigationView{
        VStack {
            
//            Text("Welcome to P2P Chat")
//                .font(Font.system(.largeTitle, design: .rounded).weight(.light))
//                .frame(width: 200, height: 200, alignment: .center)
//                .multilineTextAlignment(.center)
//                .offset(x: 0, y: -150)
            
//            Text("Please, Confirm your display name")
//                .font(Font.system(.largeTitle, design: .rounded).weight(.light))
//                .frame(width: 300, height: 200, alignment: .center)
//                .multilineTextAlignment(.center)
//                .offset(x: 0, y: -240)
            
            Text("Please, Confirm your display name")
                .font(Font.system(.largeTitle, design: .rounded).weight(.light))
                .frame(width: 300, height: 150, alignment: .center)
                .multilineTextAlignment(.center)
//                .background(.red)
                .offset(x: 0, y: -210)
            
            Text("This name is unchangeble")
                .font(Font.system(.title3, design: .rounded).weight(.regular))
                .frame(width: 200, height: 100, alignment: .center)
                .multilineTextAlignment(.center)
//                .background(.red)
                .offset(x: 0, y: -200)
            
                        
            Text(randomString)
                .foregroundColor(.white)
                .padding()
                .background(Color.gray)
                .offset(x: 0, y: -50)
//                .shadow(color: .black, radius: 3, x: 3, y: 3)
          
            
//            NavigationLink(destination: OnboardingSecond()) {
            Button(action: {
//                                self.showingDetail.toggle()
                
                            }) {
            
                                Text("Continue")
            
                            }
                            .buttonStyle(BigPaddedButtonStyle2())
                            .offset(x: 0, y: 40)
                
            
//                }
//            .buttonStyle(BigPaddedButtonStyle2())
            
                
            
            VStack {
                Text("Display name will be generated each time you open the app.")
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(width: 430, height: 130)
                    .offset(x: 0, y: 100)
            }
    }
        
       
}
    }
    
}

struct BigPaddedButtonStyle2: ButtonStyle {
    
    let steelGray = Color(white: 0.8)
    func makeBody(configuration: Configuration) -> some View {
        return configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .black)
            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(steelGray)
            .cornerRadius(10)
            .padding(10)
    }
}

struct OnboardingSecond_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSecond()
    }
}
