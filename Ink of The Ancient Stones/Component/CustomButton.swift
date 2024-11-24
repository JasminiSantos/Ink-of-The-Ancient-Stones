//
//  CustomButton.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var textColor: Color
    var leftIcon: String? = ""
    var rightIcon: String? = ""
    var iconPadding: CGFloat = 4
    var width: CGFloat = 0
    @Binding var disabled: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if let leftIcon = leftIcon {
                    Image(systemName: leftIcon)
                        .padding(.trailing, iconPadding)
                }
                
                Text(title)
                    .fontWeight(.bold)
                
                if let rightIcon = rightIcon {
                    Image(systemName: rightIcon)
                        .padding(.leading, iconPadding)
                }
            }
            .foregroundColor(textColor)
            .padding()
            .frame(maxWidth: width == 0 ? .infinity : width)
            .background(backgroundColor)
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(disabled)
    }
}

struct CustomButtonStyle: ButtonStyle {
    var title: String
    var backgroundColor: Color
    var textColor: Color
    var leftIcon: String? = ""
    var rightIcon: String? = ""
    var iconPadding: CGFloat = 4
    var width: CGFloat = 0
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            if let leftIcon = leftIcon {
                Image(systemName: leftIcon)
                    .padding(.trailing, iconPadding)
            }
            
            Text(title)
                .fontWeight(.bold)
            
            if let rightIcon = rightIcon {
                Image(systemName: rightIcon)
                    .padding(.leading, iconPadding)
            }
        }
        .foregroundColor(textColor)
        .padding()
        .frame(maxWidth: width == 0 ? .infinity : width)
        .background(backgroundColor)
        .cornerRadius(20)
    }
}

struct CustomRoundButtonStyle: ButtonStyle {
    var title: String
    var backgroundColor: Color
    var textColor: Color
    var width: CGFloat
//    var height: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: width, height: width)
            .background(
                Circle()
                    .fill(backgroundColor)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
            )
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 2)
            )
            .overlay(
                Text(title)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(textColor)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0), value: configuration.isPressed)
    }
}
