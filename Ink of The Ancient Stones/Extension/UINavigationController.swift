//
//  UINavigationController.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 29/06/24.
//

import SwiftUI

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().tintColor = CustomColors.customBrown.uicolor
    }
}

