//
//  InfoView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct InfoView: View {
    @Binding var showingOverlay: OverlayType?
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Select the tools to trace the mayan glyph.")
                .font(.system(size: 26, weight: .bold))
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .padding(.bottom, 20)
            VStack(alignment: .leading) {
                ToolInfoRow(icon: "circle.fill", text: "Select a smaller brush for fine details", size: 16)
                ToolInfoRow(icon: "circle.fill", text: "Choose a larger brush for broad strokes", size: 30)
                ToolInfoRow(icon: "trash", text: "Tap to clear your work and start fresh", size: 30)
                ToolInfoRow(icon: "pencil.tip", text: "Drag the pencil to trace and create", size: 30)
                ToolInfoRow(icon: "eraser", text: "Use the eraser to correct any mistakes", size: 30)
                ToolInfoRow(icon: "arrow.uturn.backward", text: "Revert the last change to your tracing", size: 30)
                ToolInfoRow(icon: "arrow.uturn.forward", text: "Restore the tracing you undid", size: 30)
            }
            
            HStack {
                Spacer()
                CustomButton(
                    title: "Close help",
                    backgroundColor: CustomColors.customOrange.color,
                    textColor: .white,
                    width: 200,
                    disabled: .constant(false),
                    action: {
                    showingOverlay = nil
                })
                Spacer()
            }
            .padding(.top, 15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ToolInfoRow: View {
    let icon: String
    let text: String
    let size: CGFloat

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.clear)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundColor(.white)
            }
            Text(text)
                .foregroundColor(.white)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .medium))
        }
        .padding(.vertical, 8)
    }
}



enum OverlayType {
    case alert
    case info
    case score
}
