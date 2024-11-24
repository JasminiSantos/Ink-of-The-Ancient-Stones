//
//  CustomAlertView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct CustomAlertView: View {
    let title: String
    let message: String
    let buttonText: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
            HStack(spacing: 20) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                Button(action: onConfirm) {
                    Text(buttonText)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(CustomColors.customBeige.color)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
