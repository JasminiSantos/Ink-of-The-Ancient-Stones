//
//  CustomBackButton.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 29/06/24.
//

import SwiftUI

struct CustomBackButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Spacer()
                Circle()
                    .fill(CustomColors.customBrown.color)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                    )
                Spacer()
            }
        }
    }
}
