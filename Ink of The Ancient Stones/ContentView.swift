//
//  ContentView.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var audioManager: AudioManager = AudioManager()
    
    var body: some View {
        NavigationStack {
            StoryViews()
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    UINavigationController().viewDidLoad()
                    audioManager.playSound(.background)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        MuteButton(isMuted: $audioManager.isMuted)
                    }
                }
        }
        .accentColor(CustomColors.customBrown.color)
        .environmentObject(audioManager)
    }
}
