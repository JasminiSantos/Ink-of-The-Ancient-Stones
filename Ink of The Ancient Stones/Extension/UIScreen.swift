//
//  UIScreen.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

extension UIScreen {
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
    }
    
    static var safeAreaTop: CGFloat {
        return safeAreaInsets.top
    }
    
    static var safeAreaBottom: CGFloat {
        return safeAreaInsets.bottom
    }
    
    static var safeAreaLeft: CGFloat {
        return safeAreaInsets.left
    }
    
    static var safeAreaRight: CGFloat {
        return safeAreaInsets.right
    }
}
