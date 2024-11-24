//
//  CustomPageButton.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct CustomPageButton: View {
    var image: UIImage?
    var width: CGFloat = 0

    var body: some View {
        if let image = image {
            HStack {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: width, height: width)
            }
        }
    }
}
