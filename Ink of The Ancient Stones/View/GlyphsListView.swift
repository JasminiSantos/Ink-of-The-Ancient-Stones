//
//  GlyphsListView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct GlyphsListView: View {
    @StateObject var glyphsViewModel = GlyphsListViewModel()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    @Binding var backPageTransitionDisabled: Bool
    @Binding var nextPageTransitionDisabled: Bool
    
    @Binding var glyphDrawings: [GlyphDrawing]

    var body: some View {
        VStack {
            pages
        }
        .onChange(of: glyphsViewModel.currentPage) { _ in
            backPageTransitionDisabled = false
            nextPageTransitionDisabled = false
        }
        .onAppear {
            backPageTransitionDisabled = false
            nextPageTransitionDisabled = false
        }
    }
    var pages: some View {
        ModelPages(glyphsViewModel.svgImages, currentPage: $glyphsViewModel.currentPage, backPageTransitionDisabled: $backPageTransitionDisabled, nextPageTransitionDisabled: $nextPageTransitionDisabled, navigationOrientation: .horizontal, transitionStyle: .pageCurl, hasControl: false){ i,image in
            ZStack {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(glyphsViewModel.fetchSVGImagesForPage(page: i), id: \.fileName) { svgImage in
                        NavigationLink(destination: GlyphCanvasView(svgDataStore: SVGDataStore(fileName: svgImage.fileName), animate: true)) {
                            Image(uiImage: svgImage.image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                navigationButtons
            }
            .background(
                Image("PaperTexture2")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.width, height: UIScreen.height)
            )
        }
    }
    
    var previousPageButton: some View {
        CustomPageButton(image: UIImage(named: "31-PET"), width: 60)
    }

    var nextPageButton: some View {
        CustomPageButton(image: UIImage(named: "31-PET"), width: 60)
    }
    
    var navigationButtons: some View {
        VStack {
            Spacer()
            HStack {
                if glyphsViewModel.currentPage > 0 {
                    previousPageButton
                } else {
                    InvisibleButtonPlaceholder()
                }
                
                Spacer()
                
                if glyphsViewModel.currentPage < glyphsViewModel.numberOfPages - 1 {
                    nextPageButton
                } else {
                    InvisibleButtonPlaceholder()
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct InvisibleButtonPlaceholder: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 60, height: 60)
    }
}
