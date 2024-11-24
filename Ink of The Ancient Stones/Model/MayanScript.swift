//
//  MayanScript.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import Foundation

struct Description {
    let key: String
    let desc: String
    let title: String
}

class MayanScript {
    
    func formatDescription(_ description: Description) -> String {
        let pattern = #"^(\w+[-\w\$\{\}@]+) \(([\w\s\/]+)\) \((T\d+[\.:;]\d+[a-z]?[:;]?\d*[a-z]?)\)  > ([nv\.]+)\. \"([^"]+)\"(?:; (.*))?$"#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsRange = NSRange(description.desc.startIndex..<description.desc.endIndex, in: description.desc)
            
            if let match = regex.firstMatch(in: description.desc, options: [], range: nsRange) {
                let originalForm = String(description.desc[Range(match.range(at: 1), in: description.desc)!])
                let key = String(description.desc[Range(match.range(at: 2), in: description.desc)!])
                let reference = String(description.desc[Range(match.range(at: 3), in: description.desc)!])
                let meaning = String(description.desc[Range(match.range(at: 4), in: description.desc)!])
                var additionalInfo = String(description.desc[Range(match.range(at: 5), in: description.desc)!]).trimmingCharacters(in: .whitespaces)
                
                if additionalInfo.hasPrefix(";") {
                    additionalInfo = additionalInfo.trimmingCharacters(in: CharacterSet(charactersIn: "; "))
                }
                
                var formattedDescription = "\(originalForm) (\(key)) is a Mayan term that signifies \"\(meaning)\"."
                if !additionalInfo.isEmpty {
                    formattedDescription += " \(additionalInfo)."
                }
                formattedDescription += " This term is referenced with the code \"\(reference)\", indicating its source in the Mayan hieroglyphic script."
                
                return formattedDescription
            } else {
                return "Could not format description due to regex match failure."
            }
        } catch {
            return "Regex error: \(error.localizedDescription)"
        }
    }
}
