//
//  MenuView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct MenuView: View {
    @State private var isButtonVisible = true
    
    var changeState: (ViewState) -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if UserDefaults.standard.bool(forKey: "hasPlayedStory") {
                        changeState(.glyphs)
                    }
                    else {
                        changeState(.story)
                    }
                }){
                    Image("45-KUCH@AB{}AK")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(hex: "9C7A5A"))
                        .frame(width: 100, height: 100)
                        .opacity(isButtonVisible ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 1).repeatForever(), value: isButtonVisible)
                }
                Spacer()
            }
            Spacer()
        }
        .background(
            Image("Menu")
                .resizable()
                .renderingMode(.original)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.width, height: UIScreen.height)
        )
        .onAppear {
            withAnimation {
                isButtonVisible.toggle()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
