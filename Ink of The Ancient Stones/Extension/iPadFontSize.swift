//
//  iPadFontSize.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

enum iPadModel {
    case mini, standard, air, pro11, pro129, unknown
}

class iPadFontSize {
    static func baseFontSize(forModel model: iPadModel) -> CGFloat {
        switch model {
        case .mini:
            return 14
        case .standard:
            return 16
        case .air:
            return 17
        case .pro11:
            return 18
        case .pro129:
            return 20
        case .unknown:
            return 16
        }
    }
}

struct DeviceInfo {
    static func currentiPadModel() -> iPadModel {
        let screenResolution = UIScreen.main.bounds.size
        let screenHeight = max(screenResolution.width, screenResolution.height)
        
        switch screenHeight {
        case 1024:
            return .mini
        case 1112:
            return .air
        case 1180:
            return .air
        case 1194:
            return .pro11
        case 1366:
            return .pro129
        default:
            return .unknown
        }
    }
}
