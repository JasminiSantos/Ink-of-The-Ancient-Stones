//
//  CustomFonts.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

class CustomFonts {
    enum Poppins: String {
        case regular = "Poppins-Regular"
        case italic = "Poppins-Italic"
        case bold = "Poppins-Bold"
    }

    static func font(_ name: Poppins, size: CGFloat) -> Font {
        return Font.custom(name.rawValue, size: size)
    }
    static func adaptiveFont(_ name: Poppins) -> Font {
        let baseScreenWidth: CGFloat = 768
        let currentScreenWidth = UIScreen.main.bounds.width
        let scaleFactor = currentScreenWidth / baseScreenWidth
        
        let baseFontSize: CGFloat = 23
        let adaptiveFontSize = baseFontSize * scaleFactor
        
        return Font.custom(name.rawValue, size: adaptiveFontSize)
    }
    static func checkFonts(){
        let cfURL = Bundle.main.url(forResource: "Poppins-Regular", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        var fontNames: [[AnyObject]] = []
        for name in UIFont.familyNames {
           print(name)
           fontNames.append(UIFont.fontNames(forFamilyName: name) as [AnyObject])
        }
        print(fontNames)
    }
}
extension UIFont {
    static func registerFonts(withExtension _extension: String) throws {
        try Bundle.main
            .urls(
                forResourcesWithExtension: _extension,
                subdirectory: nil
            )?
            .forEach(registerFont)
    }
    
    private static func registerFont(from fontUrl: URL) throws {
        var error: Unmanaged<CFError>?
        guard let fontData = try? Data(contentsOf: fontUrl),
              let cgData = CGDataProvider(data: fontData as CFData),
              let cgFont = CGFont(cgData)
        else { throw FontLoadingError.noFontsLoaded }
        CTFontManagerRegisterGraphicsFont(cgFont, &error)
        if let error = error {
            throw error.takeRetainedValue()
        }
    }
    
    private enum FontLoadingError: Error {
        case noFontsLoaded
    }
}
