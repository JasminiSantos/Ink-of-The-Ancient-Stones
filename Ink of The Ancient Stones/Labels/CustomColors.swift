//
//  CustomColors.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

enum CustomColors: String {
    case customBeige = "#F4EAD5"
    case customPaperBeige = "#E7D7A8"
    case customBrown = "#8B572A"
    case customTurquoise = "#00D5CE"
    case customDarkRed = "#7D1B0F"
    case customGreen = "#00B493"
    case customOrange = "#FF8C48"
    case customYellow = "#D7C144"

    var color: Color {
        switch self {
            case .customBeige:
                return Color(hex: self.rawValue)
            case .customBrown:
                return Color(hex: self.rawValue)
            case .customTurquoise:
                return Color(hex: self.rawValue)
            case .customDarkRed:
                return Color(hex: self.rawValue)
            case .customGreen:
                return Color(hex: self.rawValue)
            case .customOrange:
                return Color(hex: self.rawValue)
            case .customYellow:
                return Color(hex: self.rawValue)
            case .customPaperBeige:
                return Color(hex: self.rawValue)
        }
    }
    var uicolor: UIColor {
        switch self {
            case .customBeige:
                return UIColor(hex: "F4EAD5")
            case .customBrown:
                return UIColor(hex: "8B572A")
            case .customTurquoise:
                return UIColor(hex: "00D5CE")
            case .customDarkRed:
                return UIColor(hex: "7D1B0F")
            case .customGreen:
                return UIColor(hex: "00B493")
            case .customOrange:
                return UIColor(hex: "FF8C48")
            case .customYellow:
                return UIColor(hex: "D7C144")
            case .customPaperBeige:
                return UIColor(hex: "E7D7A8")
        }
    }
}
