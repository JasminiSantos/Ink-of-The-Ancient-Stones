//
//  EndView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct EndView: View {
    @Binding var glyphDrawings: [GlyphDrawing]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @Binding var backPageTransitionDisabled: Bool
    @Binding var nextPageTransitionDisabled: Bool

    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(glyphDrawings, id: \.imageName) { glyph in
                    VStack {
                        Image(uiImage: glyph.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                        Text(glyph.title)
                            .font(CustomFonts.adaptiveFont(.bold))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding()

            Text("We have gathered all the hieroglyphs together. This is our chance to delve into other mysteries of the ancient Maya. Are you ready to become part of history and uncover forgotten knowledge?")
                .font(CustomFonts.adaptiveFont(.regular))
                .padding(.horizontal, 20)

            Spacer()
            

            HStack {
                Spacer()
                CustomPageButton(image: UIImage(named: "31-PET"), width: 60)
            }
            .padding([.trailing, .bottom])
        }
        .background(
            Image("PaperTexture1")
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
}
