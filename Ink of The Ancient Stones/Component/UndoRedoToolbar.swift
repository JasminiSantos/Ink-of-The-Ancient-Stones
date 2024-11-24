//
//  UndoRedoToolbar.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct UndoRedoToolbar: View {
    var orientation: Orientation = .vertical
    var undoAction: () -> Void
    var redoAction: () -> Void
    
    var body: some View {
        Group {
            if orientation == .vertical {
                VStack {
                    undoRedoButtons
                }
            } else {
                HStack {
                    undoRedoButtons
                }
            }
        }
        .foregroundColor(.primary)
    }

    private var undoRedoButtons: some View {
        Group {
            
            Button(action: undoAction) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: 24))
            }
            .buttonStyle(.plain)
            .padding(orientation == .vertical ? .vertical : .horizontal, 5)
            
            Rectangle()
                .frame(width: orientation == .vertical ? 40 : 1, height: orientation == .vertical ? 1 : 40)
                .foregroundColor(.black)
            
            Button(action: redoAction) {
                Image(systemName: "arrow.uturn.forward")
                    .font(.system(size: 24))
            }
            .buttonStyle(.plain)
            .padding(orientation == .vertical ? .vertical : .horizontal, 10)
        }
    }
}

enum Orientation{
    case vertical
    case horizontal
}
