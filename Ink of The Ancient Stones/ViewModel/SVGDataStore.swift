//
//  SVGDataStore.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

class SVGDataStore: ObservableObject {
    @Published var shapes: [SVGShape] = []
    
    private let parser = SVGParser()

    init(fileName: String) {
        loadSVGPathFromFile(named: fileName)
    }
    init(){
        
    }
    func loadSVGPathFromFile(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "svg"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load data from \(fileName).svg")
            return
        }
        shapes = parser.parse(data: data)
    }
    
    func createImage(fromSVGNamed fileName: String, size: CGSize, scalingFactor: CGFloat = 0.9) -> UIImage? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "svg"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load data from \(fileName).svg")
            return nil
        }
        let shapes = self.parser.parse(data: data)
        return self.createImage(fromPaths: shapes, size: size, scalingFactor: scalingFactor)
    }
    
    func createImage(fromPaths paths: [SVGShape], size: CGSize, scalingFactor: CGFloat = 0.9) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        context.clear(CGRect(origin: .zero, size: size))
        
        let combinedPath = UIBezierPath()
        combinedPath.usesEvenOddFillRule = true
        
        for svgPath in paths {
            let bezierPath = svgPath.createBezierPath()
            combinedPath.append(bezierPath)
        }

        let scale = min(size.width / combinedPath.bounds.width, size.height / combinedPath.bounds.height) * scalingFactor
        let translateX = (size.width - combinedPath.bounds.width * scale) / 2.0 - combinedPath.bounds.minX * scale
        let translateY = (size.height - combinedPath.bounds.height * scale) / 2.0 - combinedPath.bounds.minY * scale
        let transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: translateX, y: translateY)
        combinedPath.apply(transform)

        UIColor.black.setStroke()
//        UIColor(CustomColors.glyphContours.color).setFill()
        combinedPath.stroke()
        combinedPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
