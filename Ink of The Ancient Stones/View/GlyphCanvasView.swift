//
//  GlyphCanvasView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct GlyphCanvasView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var audioManager: AudioManager
    
    @StateObject var svgDataStore = SVGDataStore(fileName: "0-e")
    @StateObject private var notePadViewModel = NotePadViewModel(lineType: .none)
    @StateObject var imageComparator = ImageComparator()
    
    @State var referenceImage: UIImage? = nil
    @State var image: UIImage? = nil
    @State var animate: Bool = false
        
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            toolbar
            
            Spacer()
            
            canvas
            
            Spacer()
            
            submit
            
            Spacer()
        }
        .onAppear {
            if referenceImage == nil {
                referenceImage = svgDataStore.createImage(fromPaths: svgDataStore.shapes, size: CGSize(width: 600, height: 600))
            }
        }
        .frame(maxWidth: .infinity)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                MuteButton(isMuted: $audioManager.isMuted)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if presentationMode.wrappedValue.isPresented {
                    CustomBackButtonView()
                }
            }
        }
        .background(
            Image("PaperTexture2")
                .resizable()
                .renderingMode(.original)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.width, height: UIScreen.height)
        )
        .overlay(
            alerts,
            alignment: .center
        )
    }
    
    var alerts: some View {
        VStack {
            switch imageComparator.showingOverlay {
                case .alert:
                    CustomAlertView(title: "Clear Canvas",
                                    message: "Are you sure you want to clear the canvas? This action cannot be undone.",
                                    buttonText: "Clear",
                                    onConfirm: { notePadViewModel.clear(); imageComparator.showingOverlay = nil },
                                    onCancel: { imageComparator.showingOverlay = nil })
                        .frame(width: 300, height: 200)
                case .info:
                    InfoView(showingOverlay: $imageComparator.showingOverlay)
                case .score:
                    ScoreView(
                        score: imageComparator.getScorePercentage(),
                        titleMainButton: "Share",
                        titleSecondaryButton: "Close",
                        shareImage: image,
                        actionMainButton: {
                        },
                        actionSecondaryButton: {
                            imageComparator.showingOverlay = nil
                            self.image = nil
                        }
                    )
                case .none:
                    EmptyView()
            }
        }
    }
    
    var toolbar: some View {
        HStack(alignment: .top) {
            Spacer()
            HStack {
                ToolPicker(
                    orientation: .horizontal,
                    selectedTool: $notePadViewModel.selectedTool,
                    brushSize: $notePadViewModel.selectedSize,
                    clearCanvas: {
                        imageComparator.showingOverlay = .alert
                    },
                    eraserAction: {
                        notePadViewModel.selectedTool = .eraser
                    }
                )
                
                UndoRedoToolbar(orientation: .horizontal, undoAction: {
                    notePadViewModel.canvasView?.undoManager?.undo()
                }, redoAction: {
                    notePadViewModel.canvasView?.undoManager?.redo()
                })
                .padding(.leading, 10)
            }
            .background(CustomColors.customBeige.color)
            .cornerRadius(12)
            
            Spacer()
            
            Button(action: {
                imageComparator.showingOverlay = .info
            }) {
                Text("?")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle()
                        .fill(CustomColors.customBrown.color))
            }
            .padding(.trailing, 20)
        }
        .padding(.top, 20)
    }
    
    var canvas: some View {
        VStack(alignment: .center) {
            ZStack {
                SVGPathViewRepresentable(svgShapes: svgDataStore.shapes, animate: animate)
                    .frame(width: 600, height: 600)
                    .cornerRadius(20)
                
                NotePad(viewModel: notePadViewModel)
                    .frame(width: 600, height: 600)
                    .cornerRadius(20)
                
                RoundedRectangle(cornerRadius: 0)
                    .stroke(CustomColors.customBrown.color.opacity(0.1), lineWidth: 1)
                    .frame(width: 600, height: 600)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 2, y: 2)
            }
        }
    }
    
    var submit: some View {
        VStack(alignment: .center) {
            CustomButton(title: "Check result",
                 backgroundColor: CustomColors.customBrown.color,
                 textColor: .white,
                 width: 200,
                 disabled: $imageComparator.processing,
                 action: {
                    if !imageComparator.processing {
                        imageComparator.processing = true
                        let capturedImages = notePadViewModel.captureCanvasDrawing()
                        if let drawingImageWithBackground = capturedImages.withBackground,
                           let referenceImage = referenceImage {
                            self.image = capturedImages.withBackground
                            self.imageComparator.getComparisonScore(originalImage1: drawingImageWithBackground, originalImage2: referenceImage) { initialScore, currentScore in
                                
                                imageComparator.processing = false
                            }
                        } else {
                            imageComparator.processing = false
                        }
                    }
                 })
        }
    }

    var stars: some View {
        Stars(scorePercentage: self.imageComparator.getScorePercentage())
            .padding(.top)
    }
}

