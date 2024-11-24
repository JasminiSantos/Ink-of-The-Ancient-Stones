//
//  IntroView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct IntroView: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Image("FirstPage")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Welcome, adventurer, to the Yucatan Peninsula! Would you like to have a walk with me?")
                    Text("Legends tell that once a great Maya civilization lived here - one of the most advanced for its time. They had knowledge in astronomy, mathematics, and architecture, as well as a unique writing system... Wait, what's that? Look closer at that hill! Do you see, there's some symbol on it?")
                }
                .font(CustomFonts.adaptiveFont(.regular))
                
                Spacer()
                
                HStack {
                    Spacer()
                    CustomPageButton(image: UIImage(named: "31-PET"), width: 60)
                }
                .padding([.trailing, .bottom])
            }
            .padding()
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            Image("PaperTexture1")
                .resizable()
                .renderingMode(.original)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.width, height: UIScreen.height)
        )
        
    }
}

#Preview {
    IntroView()
}
