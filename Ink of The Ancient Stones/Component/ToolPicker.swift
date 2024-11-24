//
//  ToolPicker.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct ToolPicker: View {
    var orientation: Orientation = .vertical
    @Binding var selectedTool: DrawingTool
    @Binding var brushSize: CGFloat
    var clearCanvas: () -> Void
    var eraserAction: () -> Void
    
    private let brushSizes: [CGFloat] = [10, 15]
    private let buttonSize: CGFloat = 30
    
    var body: some View {
        Group {
            if orientation == .vertical {
                VStack(spacing: 20) {
                    tools
                }
            } else {
                HStack(spacing: 20) {
                    tools
                }
            }
        }
        .padding()
    }
    
    var tools: some View {
        Group {
            ForEach(brushSizes, id: \.self) { size in
                Button(action: {
                    brushSize = size
                    selectedTool = .pencil(.black, size)
                }) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: size + 10, height: size + 10)
                }
                .overlay(
                    brushSize == size
                    ? Circle().stroke(Color.black, lineWidth: 2)
                        .frame(width: buttonSize + 15, height: buttonSize + 15)
                    : nil
                )
            }

            
            Button(action: clearCanvas) {
                Image(systemName: "trash")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: buttonSize, height: buttonSize)
            }
            
            Button(action: eraserAction) {
                Image(systemName: "eraser")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: buttonSize, height: buttonSize)
            }
            .overlay(
                selectedTool == .eraser
                ? Circle().stroke(Color.black, lineWidth: 2)
                    .frame(width: buttonSize + 15, height: buttonSize + 15)
                : nil
            )
            
            Button(action: {
                selectedTool = .pencil(.black, brushSize)
            }) {
                Image(systemName: "pencil.tip")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: buttonSize, height: buttonSize)
            }
            .overlay(
                selectedTool == .pencil(.black, brushSize)
                ? Circle().stroke(Color.black, lineWidth: 2)
                    .frame(width: buttonSize + 15, height: buttonSize + 15)
                : nil
            )
        }
    }
}
