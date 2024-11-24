//
//  StoryViews.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct StoryViews: View {
    
    @State var glyphDrawings: [GlyphDrawing] = []
    
    @State var currentPage = 0
    @State var backPageTransitionDisabled: Bool = false
    @State var nextPageTransitionDisabled: Bool = false
    
    @State var viewState: ViewState = .menu
    

    var images = ["34-JOL-lo", "39-IN@KAB{}", "49-CH{}UL$K{}UL@(CH{}UJUL$K{}UJUL)", "29-CHAK"]
    
    var body: some View {
        Group {
            switch viewState {
                case .menu:
                    menu
                case .story:
                    story
                case .glyphs:
                    glyphs
            }
        }
//        .animation(.easeInOut(duration: 0.5), value: viewState)
    }
    
    var story: some View {
        Pages(currentPage: $currentPage,backPageTransitionDisabled: $backPageTransitionDisabled, nextPageTransitionDisabled: $nextPageTransitionDisabled, navigationOrientation: .horizontal, transitionStyle: .pageCurl, hasControl: false) {

            IntroView()
            
            GlyphCanvasStoryView(
                svgDataStore: SVGDataStore(fileName: images[0]),
                backPageTransitionDisabled: $backPageTransitionDisabled,
                nextPageTransitionDisabled: $nextPageTransitionDisabled,
                glyphDrawings: $glyphDrawings,
                storyPart: StoryPart.jolLo
            )
            
            
            GlyphCanvasStoryView(
                svgDataStore: SVGDataStore(fileName: images[1]),
                backPageTransitionDisabled: $backPageTransitionDisabled,
                nextPageTransitionDisabled: $nextPageTransitionDisabled,
                glyphDrawings: $glyphDrawings,
                storyPart: StoryPart.inKab
            )
            
            GlyphCanvasStoryView(svgDataStore:
                SVGDataStore(fileName: images[2]),
                backPageTransitionDisabled: $backPageTransitionDisabled,
                nextPageTransitionDisabled: $nextPageTransitionDisabled,
                glyphDrawings: $glyphDrawings,
                storyPart: StoryPart.chulKul
            )
    
            
            GlyphCanvasStoryView(svgDataStore:
                SVGDataStore(fileName: images[3]),
                backPageTransitionDisabled: $backPageTransitionDisabled,
                nextPageTransitionDisabled: $nextPageTransitionDisabled,
                glyphDrawings: $glyphDrawings,
                storyPart: StoryPart.chak
            )

            EndView(
                glyphDrawings: $glyphDrawings,
                backPageTransitionDisabled: $backPageTransitionDisabled,
                nextPageTransitionDisabled: $nextPageTransitionDisabled
            )
            
            DrawingsView(
                backPageTransitionDisabled: $backPageTransitionDisabled,
                nextPageTransitionDisabled: $nextPageTransitionDisabled,
                changeState: { newState in
                    withAnimation(.easeInOut(duration: 1.0)) {
                        viewState = newState
                    }
                }
            )
            
        }
    }
    
    var glyphs: some View {
        GlyphsListView(
            backPageTransitionDisabled: $backPageTransitionDisabled,
            nextPageTransitionDisabled: $nextPageTransitionDisabled,
            glyphDrawings: $glyphDrawings
        )
    }
    
    var menu: some View {
        MenuView(changeState: { newState in
            withAnimation(.easeInOut(duration: 1.0)) {
                currentPage = 0
                backPageTransitionDisabled = false
                nextPageTransitionDisabled = false
                glyphDrawings = []
                viewState = newState
            }
        })
    }
    
}

enum ViewState {
    case menu
    case story
    case glyphs
}
