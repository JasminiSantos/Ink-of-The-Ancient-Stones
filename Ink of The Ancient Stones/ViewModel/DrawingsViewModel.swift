//
//  DrawingsViewModel.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

class DrawingsViewModel: ObservableObject {
    @Published var glyphDrawings: [GlyphDrawing] = []
    
    init() {
        self.glyphDrawings = generateGlyphDrawings()
    }
    
    private func generateGlyphDrawings() -> [GlyphDrawing] {
        let glyphCount = glyphCountBasedOnScreenSize
        return (1...glyphCount).compactMap { i in
            guard let image = UIImage(named: "Drawing\(i)") else { return nil }
            return GlyphDrawing(
                title: "",
                imageName: image
            )
        }
    }
    
    private var glyphCountBasedOnScreenSize: Int {
        let maxScreenDimension = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        if maxScreenDimension >= 1024 {
            return 9
        } else if maxScreenDimension >= 768 {
            return 6
        } else {
            return 4
        }
    }
    
    var columns: [GridItem] {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfColumns = screenWidth > 600 ? 3 : 2
        return Array(repeating: .init(.flexible()), count: numberOfColumns)
    }

    var imageWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfColumns = CGFloat(columns.count)
        let padding: CGFloat = 20
        let availableWidth = screenWidth - (padding * 2) - (padding * (numberOfColumns - 1))
        return availableWidth / numberOfColumns
    }
}
