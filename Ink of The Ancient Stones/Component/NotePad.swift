//
//  NotePad.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI
import PencilKit

struct NotePad: UIViewRepresentable {
    @ObservedObject var viewModel: NotePadViewModel
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView(frame: .zero)
        var linedBackground: UIView? = nil
        
        if viewModel.lineType == .dotted {
            linedBackground = DottedLineBackgroundView()
        }
        else if viewModel.lineType == .normal {
            linedBackground = LineBackgroundView()
        }
        
        let canvas = PKCanvasView()
        canvas.backgroundColor = .clear
        canvas.delegate = context.coordinator
        canvas.tool = PKInkingTool(.pen, color: UIColor(viewModel.selectedColor), width: 5)
        canvas.drawingPolicy = .anyInput
        viewModel.canvasView = canvas
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.isExclusiveTouch = true
        container.addSubview(canvas)
        
        NSLayoutConstraint.activate([
            canvas.topAnchor.constraint(equalTo: container.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            canvas.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ])
        
        if let linedBackground = linedBackground {
            linedBackground.backgroundColor = .clear
            linedBackground.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(linedBackground)
            linedBackground.isUserInteractionEnabled = false
            
            NSLayoutConstraint.activate([
                linedBackground.topAnchor.constraint(equalTo: container.topAnchor),
                linedBackground.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                linedBackground.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                linedBackground.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            ])
        }
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let canvasView = viewModel.canvasView else { return }

        if viewModel.clearCanvas {
            canvasView.drawing = PKDrawing()
            DispatchQueue.main.async {
                viewModel.clearCanvas = false
            }
        }
        
        switch viewModel.selectedTool {
            case .pencil(let color, let size):
                canvasView.tool = PKInkingTool(.pen, color: UIColor(color), width: size)
            case .eraser:
                canvasView.tool = PKEraserTool(.bitmap)
        }
        canvasView.drawing = viewModel.canvasView!.drawing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: NotePad
        var viewModel: NotePadViewModel
        
        private var lastUpdateTime = Date()
        private let updateInterval = 0.5
        
        init(_ parent: NotePad, viewModel: NotePadViewModel) {
            self.parent = parent
            self.viewModel = viewModel
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let now = Date()
            if now.timeIntervalSince(lastUpdateTime) > updateInterval {
                lastUpdateTime = now
                processDrawing(canvasView.drawing)
            }
        }
        
        private func processDrawing(_ drawing: PKDrawing) {
            DispatchQueue.global(qos: .userInitiated).async {
                let allPoints = self.extractStrokePoints(from: drawing)
                DispatchQueue.main.async {
                    self.viewModel.updateStrokePoints(allPoints)
                }
            }
        }
        
        private func extractStrokePoints(from drawing: PKDrawing) -> [[CGPoint]] {
            var allPoints = [[CGPoint]]()
            for stroke in drawing.strokes {
                var strokePoints = [CGPoint]()
                let path = stroke.path
                for i in 0..<path.count {
                    let controlPoint = path.interpolatedLocation(at: CGFloat(i) / CGFloat(path.count))
                    strokePoints.append(controlPoint)
                }
                allPoints.append(strokePoints)
            }
            return allPoints
        }
    }

}
class LineBackgroundView: UIView {

    var lineSpacing: CGFloat = 45
    var linePadding: CGFloat = 20

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineWidth(1)
        context.setStrokeColor(UIColor.gray.cgColor)

        var startY: CGFloat = 0
        while startY < rect.height {
            context.move(to: CGPoint(x: linePadding, y: startY))
            context.addLine(to: CGPoint(x: rect.width - linePadding, y: startY))
            context.strokePath()
            startY += lineSpacing
        }
    }
}


class DottedLineBackgroundView: UIView {
    
    var lineSpacing: CGFloat = 40
    var linePadding: CGFloat = 20
    var dotSpacing: CGFloat = 5

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.gray.cgColor)
        
        let dashPattern: [CGFloat] = [3, dotSpacing]

        var startY: CGFloat = lineSpacing
        while startY < rect.height {
            context.setLineDash(phase: 0, lengths: dashPattern)
            context.move(to: CGPoint(x: linePadding, y: startY))
            context.addLine(to: CGPoint(x: rect.width - linePadding, y: startY))
            context.strokePath()
            startY += lineSpacing
        }
    }
}

extension PKDrawing {
    var isEmpty: Bool {
        return self.strokes.isEmpty
    }
    var isNotEmpty: Bool {
        return !self.strokes.isEmpty
    }
}
