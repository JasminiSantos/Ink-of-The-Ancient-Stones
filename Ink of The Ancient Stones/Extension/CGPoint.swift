//
//  CGPoint.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

extension CGPoint {
    init?(svgString: String) {
        let components = svgString.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
        if components.count == 2 {
            self.init(x: components[0], y: components[1])
        } else {
            return nil
        }
    }
}
