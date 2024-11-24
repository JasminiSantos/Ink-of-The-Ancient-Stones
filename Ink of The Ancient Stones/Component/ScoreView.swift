//
//  ScoreView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct ScoreView: View {
    var score: Double
    var titleMainButton: String
    var titleSecondaryButton: String? = ""
    var shareImage: UIImage? = nil
    
    var actionMainButton: () -> Void
    var actionSecondaryButton: () -> Void = {}
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                
                Stars(scorePercentage: score)
                    .padding(.bottom)
                
                Text(descriptionForScore())
                    .font(.custom("Poppins-Regular", size: 25))
                    .foregroundColor(.white)
                    .padding()
                
                Text("\(score.formatPercentage())")
                    .font(.custom("Poppins-Bold", size: 50))
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                
                Text(scoreMessage())
                    .font(.custom("Poppins-Regular", size: 25))
                    .foregroundColor(.white)
                    .padding()
                
                HStack(alignment: .center, spacing: 20) {
                    if let image = shareImage, let imageData = image.pngData() {
                        ShareLink(item: imageData, preview: SharePreview("Drawing", image: Image(uiImage: image))) {
                            HStack(spacing: 20) {
                                Text(titleMainButton)
                            }
                        }
                        .buttonStyle(CustomButtonStyle(title: "Share", backgroundColor: CustomColors.customOrange.color, textColor: .white, width: 200))
                    } else {
                        CustomButton(
                            title: titleMainButton,
                            backgroundColor: CustomColors.customOrange.color,
                            textColor: .white,
                            disabled: .constant(false),
                            action: {
                                actionMainButton()
                            })
                        .frame(width: 200, height: 200)
                    }

                    if let titleSecondary = titleSecondaryButton, !titleSecondary.isEmpty {
                        CustomButton(
                            title: titleSecondary,
                            backgroundColor: CustomColors.customGreen.color,
                            textColor: .white,
                            disabled: .constant(false),
                            action: {
                                actionSecondaryButton()
                            })
                        .frame(width: 200, height: 200)
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
    }
    
    private func scoreMessage() -> String {
        switch score {
        case 90...100:
            return "You're a Mayan glyph master!"
        case 70..<90:
            return "Great job, you're getting there!"
        case 50..<70:
            return "Good effort, keep studying the glyphs!"
        default:
            return "Keep trying, you'll improve with practice!"
        }
    }
    
    private func descriptionForScore() -> String {
        switch score {
        case 90...100:
            return "Your mastery is evident. Keep up the great work!"
        case 70..<90:
            return "You're on the right track. A bit more practice will make perfect!"
        case 50..<70:
            return "A solid effort. With more study, you'll get there!"
        default:
            return "Every master was once a beginner. Don't give up!"
        }
    }
    private func titleForScore() -> String {
        switch score {
        case 90...100:
            return "Outstanding!"
        case 70..<90:
            return "Well Done!"
        case 50..<70:
            return "Good Effort!"
        default:
            return "Keep Trying!"
        }
    }
}

