//
//  NotePadViewModel.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI
import PencilKit

@MainActor
class NotePadViewModel: ObservableObject {
    @Published var selectedTool: DrawingTool = .pencil(.black, 5)
    @Published var selectedColor: Color = .black
    @Published var selectedSize: CGFloat = 5
    @Published var clearCanvas: Bool = false
    @Published var canvasView: PKCanvasView?
    @Published var lineType: LineType = .none

    @Published var strokePoints: [[CGPoint]] = []
    
    init(lineType: LineType = .none) {
            self.lineType = lineType
    }
    init() {
        self.canvasView = PKCanvasView()
        self.canvasView?.drawing = PKDrawing()
    }

    var undoManager: UndoManager? {
        return canvasView?.undoManager
    }
    
    func undo() {
        undoManager?.undo()
    }
    
    func redo() {
        undoManager?.redo()
    }
    
    func clear() {
        canvasView?.drawing = PKDrawing()
    }
    
    func storeStrokePoints(_ points: [[CGPoint]]) {
        DispatchQueue.main.async {
            self.strokePoints.append(contentsOf: points)
        }
    }
    
    func updateStrokePoints(_ newPoints: [[CGPoint]]) {
        self.strokePoints = newPoints
    }
    
    func captureCanvasDrawing() -> (original: UIImage?, withBackground: UIImage?) {
        guard let canvas = canvasView else { return (nil, nil) }
        let drawing = canvas.drawing
        let originalImage = drawing.image(from: canvas.bounds, scale: UIScreen.main.scale)
        let imageWithBackground = originalImage.withBackground(color: .white)
        return (originalImage, imageWithBackground)
    }
}

enum LineType {
    case normal
    case dotted
    case none
}
enum DrawingTool: Equatable {
    case pencil(Color, CGFloat)
    case eraser
}
