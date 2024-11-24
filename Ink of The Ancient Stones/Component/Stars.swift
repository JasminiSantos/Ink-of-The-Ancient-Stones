//
//  Stars.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct Stars: View {
    let scorePercentage: Double
    private let totalStars = 3
    
    var body: some View {
        HStack {
            ForEach(0..<totalStars, id: \.self) { index in
                Image("19-LAMAT")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(colorForStar(at: index))
                    .frame(width: 100, height: 100)
            }
        }
    }
    
    private func colorForStar(at index: Int) -> Color {
        switch scorePercentage {
        case let score where score >= 70:
            return .init(hex: "FF8C48")
        case let score where score >= 40:
            return index < 2 ? .init(hex: "FF8C48") : .gray
        default:
            return index == 0 ? .init(hex: "FF8C48") : .gray
        }
    }
}
