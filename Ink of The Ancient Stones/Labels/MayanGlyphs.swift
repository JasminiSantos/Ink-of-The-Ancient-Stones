//
//  MayanGlyphs.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

enum MayanGlyphs: Identifiable, CaseIterable {
    case jolLo(key: String, description: String)
    case inKab(key: String, description: String)
    case chulKul(key: String, description: String)
    case chak(key: String, description: String)

    var id: String {
        switch self {
        case .jolLo(let key, _), .inKab(let key, _), .chulKul(let key, _), .chak(let key, _):
            return key
        }
    }

    var keyAndDescription: (key: String, description: String) {
        switch self {
        case .jolLo(let key, let description),
             .inKab(let key, let description),
             .chulKul(let key, let description),
             .chak(let key, let description):
            return (key, description)
        }
    }

    static var allCases: [MayanGlyphs] {
        [
            .jolLo(key: "34-JOL-lo", description: "JOL-lo (jol) (T1040[580]) > n. \"head\""),
            .inKab(key: "39-IN@KAB{}", description: "IN KAB' (in kab') (T116.526) > poss. n. \"my earth,\" \"my land\"; includes the first person possessive pronoun in- \"my.\""),
            .chulKul(key: "49-CH{}UL$K{}UL@(CH{}UJUL$K{}UJUL)", description: "CH'UL/K'UL (CH'UJUL/K'UJUL) (ch'ul/k'ul, ch'ujul/k'ujul) (T37) > adj. \"sacred, holy, divine\"; incorporates a visual and conceptual analogy between blood and the soul; derives from the word ch'ulel in several Mayan languages, meaning \"soul, holiness, divinity, spirituality\""),
            .chak(key: "29-CHAK", description: "CHAK (chak) (T590v) 1> adj. \"red\" 2> adj. \"great\"")
        ]
    }
    
}

struct GlyphDrawing {
    let title: String
    let imageName: UIImage
}
