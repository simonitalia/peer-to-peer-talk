//
//  OnboardingFirst.swift
//  peer-to-peer-talk
//
//  Created by Глеб Малов on 15/02/22.
//

import SwiftUI

struct OnboardingFirst: View {
    
    
    let picker_values = ["Russian", "Chinese", "English", "Italian", "Japanese"]
    @State private var selectedLanguage = "English"
    @State var showingDetail = false
    @State private var languageIdentifier = "en"

    var body: some View {
        NavigationView{
        VStack {
        
            Text("Welcome to P2P Chat")
                .font(Font.system(.largeTitle, design: .rounded).weight(.light))
                .frame(width: 200, height: 150, alignment: .center)
                .multilineTextAlignment(.center)
//                .background(.red)
                .offset(x: 0, y: -200)
            
            Text("Please, Choose your language")
                .font(Font.system(.title3, design: .rounded).weight(.regular))
                .frame(width: 200, height: 100, alignment: .center)
                .multilineTextAlignment(.center)
//                .background(.red)
                .offset(x: 0, y: -160)
            
            VStack {
                Picker("Please choose your language", selection: $selectedLanguage) {
                                ForEach(picker_values, id: \.self) {
                                    Text($0)
            }
                }
                .pickerStyle(.wheel)
                .offset(x: 0, y: -20)
                Button(action: {
    //                                self.showingDetail.toggle()
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                }) {
                                    HStack{
                                        
                                        Image(systemName: "gear")
                                            .foregroundColor(Color.black)
                                            
                                        Text("App Settings")
                                            .foregroundColor(Color.black)
                                    }
                
                                }
                                .buttonStyle(BigPaddedButtonStyle2())
                                .offset(x: 0, y: -60)
                                .shadow(color: .black, radius: 3, x: 3, y: 3)
                                
             
            }
            
            NavigationLink(destination: OnboardingSecond().navigationBarBackButtonHidden(true)) {
                Text("Confirm")
                }
            .buttonStyle(BigPaddedButtonStyle())
            
            
                
            
            VStack {
                Text("Please confirm language that you want to use in this app.")
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(width: 290, height: 120)
                    .offset(x: 0, y: 40)
            }
    }
        
       
}
    }
    
}


//struct BigPaddedButtonStyle: ButtonStyle {
//    
//    let steelGray = Color(white: 0.8)
//    func makeBody(configuration: Configuration) -> some View {
//        return configuration
//            .label
//            .foregroundColor(configuration.isPressed ? .gray : .black)
//            .padding(EdgeInsets(top: 0, leading: 110, bottom: 0, trailing: 110))
//            .frame(minWidth: 0, maxWidth: .infinity)
//            .padding()
//            .background(steelGray)
//            .cornerRadius(10)
//            .padding(10)
//    }
//}


struct OnboardingFirst_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFirst()
    }
}
