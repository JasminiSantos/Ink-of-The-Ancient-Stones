//
//  CustomNavigationBar.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 29/06/24.
//

import SwiftUI

struct MuteButton: View {
    @Binding var isMuted: Bool
    
    var body: some View {
        Button(action: {
            isMuted.toggle()
        }) {
            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.2.fill")
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(CustomColors.customBrown.color)
        }
    }
}
