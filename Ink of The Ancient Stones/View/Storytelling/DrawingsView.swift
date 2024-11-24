//
//  DrawingsView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct DrawingsView: View {
    @Binding var backPageTransitionDisabled: Bool
    @Binding var nextPageTransitionDisabled: Bool
    
    @StateObject private var viewModel = DrawingsViewModel()
    
    var changeState: (ViewState) -> Void

    var body: some View {
        VStack {
            LazyVGrid(columns: viewModel.columns) {
                ForEach(viewModel.glyphDrawings, id: \.imageName) { glyph in
                    VStack {
                        Image(uiImage: glyph.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: viewModel.imageWidth)
                        Text(glyph.title)
                            .font(CustomFonts.adaptiveFont(.bold))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding(.horizontal)
            
            VStack {
                Text("Join our fellow explorers in unveiling Mayan glyphs, contributing to a collective journey of discovery. Engage, practice, and keep the ancient wisdom alive. Ready to be part of history?")
                    .font(CustomFonts.adaptiveFont(.regular))
                
                HStack(alignment: .center, spacing: 20) {
                    CustomButton(
                        title: "Find New Glyphs",
                        backgroundColor: CustomColors.customGreen.color,
                        textColor: .white,
                        width: 200,
                        disabled: .constant(false),
                        action: {
                            finishedGame()
                            changeState(.glyphs)
                    })
                    
                    CustomButton(
                        title: "Finish Game",
                        backgroundColor: CustomColors.customOrange.color,
                        textColor: .white,
                        width: 200,
                        disabled: .constant(false),
                        action: {
                            finishedGame()
                            changeState(.menu)
                    })
                }
            }
            .padding(.horizontal, 20)
        }
        .background(
            Image("PaperTexture2")
                .resizable()
                .renderingMode(.original)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.width, height: UIScreen.height)
        )
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                backPageTransitionDisabled = true
                nextPageTransitionDisabled = false
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                backPageTransitionDisabled = true
                nextPageTransitionDisabled = false
            }
        }
        
    }
    func finishedGame(){
        UserDefaults.standard.set(true, forKey: "hasPlayedStory")
    }
}
