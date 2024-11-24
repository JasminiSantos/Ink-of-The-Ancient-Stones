//
//  SVGPathView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct SVGPathViewRepresentable: UIViewRepresentable {
    var svgShapes: [SVGShape]
    
    var animate: Bool = false
    
    func makeUIView(context: Context) -> SVGPathView {
        return SVGPathView(shouldAnimate: animate ? true : false)
    }

    func updateUIView(_ uiView: SVGPathView, context: Context) {
        uiView.svgShapes = svgShapes
        uiView.shouldAnimate = animate
    }
}

class SVGPathView: UIView {
    var shouldAnimate: Bool = false {
        didSet {
            if shouldAnimate {
                if let shapeLayer = shapeLayer {
                    animatePathDrawing(shapeLayer: shapeLayer)
                }
            }
        }
    }
    private var shapeLayer: CAShapeLayer?
    
    var svgShapes: [SVGShape]? {
        didSet {
            setupPath()
        }
    }
    
    init(shouldAnimate: Bool = false) {
        self.shouldAnimate = shouldAnimate
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
            super.didMoveToWindow()
            if window != nil, shouldAnimate {
                setupPath()
            }
        }
    
    private func setupPath() {
        guard let svgShapes = svgShapes else { return }
        let combinedPath = UIBezierPath()
        combinedPath.usesEvenOddFillRule = true


        for shape in svgShapes {
            let bezierPath = shape.createBezierPath()
            combinedPath.append(bezierPath)
        }

        let scaledAndCenteredPath = centerAndScalePath(combinedPath, scalingFactor: 0.9)

        shapeLayer?.removeFromSuperlayer()

        let newShapeLayer = CAShapeLayer()
        newShapeLayer.path = scaledAndCenteredPath.cgPath
        newShapeLayer.strokeColor = UIColor.black.cgColor
        newShapeLayer.lineWidth = 1
        newShapeLayer.fillColor = UIColor.clear.cgColor
        newShapeLayer.opacity = 0.25

        self.layer.addSublayer(newShapeLayer)
        shapeLayer = newShapeLayer

        if shouldAnimate {
            animatePathDrawing(shapeLayer: newShapeLayer)
        }
        else {
            shapeLayer?.fillColor = UIColor.black.cgColor
        }
    }

    private func animatePathDrawing(shapeLayer: CAShapeLayer) {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = 7.0

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = strokeEndAnimation.duration + 0.1
        animationGroup.animations = [strokeEndAnimation]

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.opacity = 0.25
        }

        shapeLayer.add(animationGroup, forKey: "strokeEndAnimation")

        CATransaction.commit()
    }
    
    private func centerAndScalePath(_ bezierPath: UIBezierPath, scalingFactor: CGFloat = 1.0) -> UIBezierPath {
        let pathBounds = bezierPath.bounds
        let scaleX = self.bounds.width / pathBounds.width * scalingFactor
        let scaleY = self.bounds.height / pathBounds.height * scalingFactor
        let scale = min(scaleX, scaleY)
        
        let translateX = (self.bounds.width - pathBounds.width * scale) / 2.0 - pathBounds.minX * scale
        let translateY = (self.bounds.height - pathBounds.height * scale) / 2.0 - pathBounds.minY * scale
        
        let transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: translateX, y: translateY)
        bezierPath.apply(transform)
        
        return bezierPath
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        if let svgPaths = svgShapes, let shapeLayer = shapeLayer {
            let combinedPath = UIBezierPath()
            combinedPath.usesEvenOddFillRule = true

            for svgPath in svgPaths {
                let bezierPath = svgPath.createBezierPath()
                combinedPath.append(bezierPath)
            }

            let scaledAndCenteredPath = centerAndScalePath(combinedPath, scalingFactor: 0.9)
            shapeLayer.path = scaledAndCenteredPath.cgPath
        }
    }
}
