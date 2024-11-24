//
//  GlyphCanvasStoryView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct GlyphCanvasStoryView: View {
    @StateObject var svgDataStore = SVGDataStore(fileName: "0-e")
    @StateObject private var notePadViewModel = NotePadViewModel(lineType: .none)
    @StateObject var imageComparator = ImageComparator()
    
    @Binding var backPageTransitionDisabled: Bool
    @Binding var nextPageTransitionDisabled: Bool
    
    @State var done: Bool = false
    @State var animate: Bool = false
    
    @Binding var glyphDrawings: [GlyphDrawing]
    
    @State var referenceImage: UIImage? = nil

    var storyPart: StoryPart
        
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            if !done {
                toolbar
                Spacer()
            }
            
            canvas
            
            if !done{
                Spacer()
                submit
                Spacer()
            }
            else {
                message
                Spacer()
                nextPageButton
            }
        }
        .frame(maxWidth: .infinity)
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
        .onAppear {
            backPageTransitionDisabled = true
            nextPageTransitionDisabled = !done
            animate = !done

            if referenceImage == nil {
                referenceImage = svgDataStore.createImage(fromPaths: svgDataStore.shapes, size: CGSize(width: 600, height: 600))
            }
        }
        .onDisappear {
            backPageTransitionDisabled = true
            nextPageTransitionDisabled = done
        }
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
                ScoreView(score: imageComparator.getScorePercentage(),
                    titleMainButton: "Improve sketch",
                    titleSecondaryButton: "Continue Story",
                    actionMainButton: {
                    imageComparator.showingOverlay = nil
                    glyphDrawings.removeLast()
                }, actionSecondaryButton: {
                    backPageTransitionDisabled = true
                    nextPageTransitionDisabled = false
                    imageComparator.showingOverlay = nil
                    done = true
                })
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
            if !done {
                ZStack {
                    SVGPathViewRepresentable(svgShapes: svgDataStore.shapes, animate: animate)
                        .frame(width: 600, height: 600)
                    
                    NotePad(viewModel: notePadViewModel)
                        .frame(width: 600, height: 600)
                        .cornerRadius(20)
                        .disabled(done)
                    
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(CustomColors.customBrown.color.opacity(0.1), lineWidth: 1)
                        .frame(width: 600, height: 600)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 2, y: 2)
                }
            }
            else {
                if let image = glyphDrawings.last?.imageName {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 600, height: 600)
                        .padding(.top)
                }
            }
            
            if done {
                Text(storyPart.title)
                    .font(CustomFonts.adaptiveFont(.bold))
            }
        }
    }
    var message: some View {
        VStack(alignment: .leading) {
            ForEach(storyPart.content.texts, id: \.self) { text in
                Text(text)
                    .font(CustomFonts.adaptiveFont(.regular))
            }
        }
        .padding(.horizontal)
    }
    
    var submit: some View {
        VStack(alignment: .center) {
            CustomButton(title: "Check result",
                 backgroundColor: CustomColors.customBrown.color,
                 textColor: .white,
                 width: 200,
                 disabled: $imageComparator.processing,
                 action: {
                    if !imageComparator.processing{
                        imageComparator.processing = true
                        let capturedImages = notePadViewModel.captureCanvasDrawing()
                        if let drawingImageWithBackground = capturedImages.withBackground,
                           let referenceImage = referenceImage {
                            self.imageComparator.getComparisonScore(originalImage1: drawingImageWithBackground, originalImage2: referenceImage) { initialScore, currentScore in
                                
                                imageComparator.processing = false
                                if let drawingImageOriginal = capturedImages.original {
                                    glyphDrawings.append(GlyphDrawing(title: storyPart.title, imageName: drawingImageOriginal))
                                }
                            }
                        } else {
                            imageComparator.processing = false
                        }
                    }
                 })
        }
    }

    var nextPageButton: some View {
        HStack {
            Spacer()
            CustomPageButton(image: UIImage(named: "31-PET"), width: 60)
        }
        .padding([.trailing, .bottom])
    }
    var stars: some View {
        Stars(scorePercentage: self.imageComparator.getScorePercentage())
            .padding(.top)
    }
}

