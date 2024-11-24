//
//  Ink_of_The_Ancient_StonesApp.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

@main
struct MyApp: App {
    
    init() {
        try! UIFont.registerFonts(withExtension: "ttf")
        try! UIFont.registerFonts(withExtension: "otf")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
