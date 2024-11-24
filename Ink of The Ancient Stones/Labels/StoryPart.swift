//
//  StoryPart.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

enum StoryPart: CaseIterable, Identifiable {
    case intro, jolLo, inKab, chulKul, chak, end

    var id: StoryPart { self }
    
    var glyph: MayanGlyphs? {
        switch self {
        case .intro:
            return nil
        case .jolLo:
            return .jolLo(key: "34-JOL-lo", description: "The 'head' glyph representing leadership and wisdom.")
        case .inKab:
            return .inKab(key: "39-IN@KAB{}", description: "'My land' glyph showing the Maya's reverence for nature.")
        case .chulKul:
            return .chulKul(key: "49-CH{}UL$K{}UL@(CH{}UJUL$K{}UJUL)", description: "The 'sacred' glyph, embodying holiness and divine connection.")
        case .chak:
            return .chak(key: "29-CHAK", description: "'Red' and 'great', symbolizing strength, life, power, and authority.")
        case .end:
            return nil
        }
    }
    
    var title: String {
        switch self {
            case .intro:
                return "Introduction"
            case .jolLo:
                return "JOL-lo (jol)"
            case .inKab:
                return "IN KAB' (in kab')"
            case .chulKul:
                return "CH'UL/K'UL (CH'UJUL/K'UJUL)"
            case .chak:
                return "CHAK (chak)"
        case .end:
                return "End"
        }
    }

    var content: (image: String?, texts: [String]) {
        switch self {
        case .intro:
            return ("FirstPage", [
                "Welcome, adventurer, to the Yucatan Peninsula! Would you like to have a walk with me?",
                "Legends tell that once a great Maya civilization lived here - one of the most advanced for its time. They had knowledge in astronomy, mathematics, and architecture, as well as a unique writing system... Wait, what's that? Look closer at that hill! Do you see, there's some symbol on it?"
            ])
        case .jolLo:
            return (nil, [
                "Congratulations, we've found an ancient Maya pyramid! And even deciphered the first hieroglyph! It is pronounced as 'JOL-lo' and means 'head'. It is said that in the Maya culture, the head symbolized leadership and wisdom - hence the Maya often depicted their rulers and gods with large heads, indicating their great power and intellect.",
                "Let's go inside - I saw another symbol there!"
            ])
        case .inKab:
            return (nil, [
                "This one was a bit like a jellyfish, wasn't it? But actually, it means 'my land' and is read as 'IN KAB'. The Maya deeply revered nature and considered the land a sacred gift from the gods. They were virtuosos in agriculture, growing corn, beans, and cocoa on their lands.",
                "By the way, when you touched it, I heard some noise from the side. Let's move on!"
            ])
        case .chulKul:
            return (nil, [
                "Research tells us that this is the 'CH'UL/K'UL' hieroglyph. It embodies holiness. The Maya believed that blood had magical power and used it in their rituals - it connected them with the gods and the spiritual world. We're getting close to something big... Look - there's a dragon!"
            ])
        case .chak:
            return (nil, [
                "And here is 'CHAK'. It has two meanings: 'red' and 'great'. The color red was very significant in Maya culture, it was associated with strength and life. And greatness, obviously, symbolized power and authority. Perhaps that's why this hieroglyph looks like a dragon. Fascinating!"
            ])
        case .end:
            return (nil, [
                "We have gathered all the hieroglyphs together. This is our chance to delve into other mysteries of the ancient Maya. Are you ready to become part of history and uncover forgotten knowledge?"
            ])
        }
    }
}
