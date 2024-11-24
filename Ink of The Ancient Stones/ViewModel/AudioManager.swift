//
//  AudioManager.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import Foundation
import AVFoundation
import SwiftUI

enum SoundType {
    case background
}

class AudioManager: ObservableObject {
    @Published var isMuted: Bool = false {
         didSet {
             updateVolume()
         }
     }
    
    private var audioPlayers: [SoundType: AVAudioPlayer] = [:]

    init() {
        prepareAudio()
    }

    private func prepareAudio() {
        prepareAudioPlayer(for: .background, fileName: "music", fileType: "mp3")
    }

    private func prepareAudioPlayer(for soundType: SoundType, fileName: String, fileType: String) {
        guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            print("Could not find sound url for \(fileName).\(fileType)")
            return
        }

        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            if soundType == .background {
                audioPlayer.numberOfLoops = -1
            }
            else {
                audioPlayer.numberOfLoops = 0
            }
            audioPlayers[soundType] = audioPlayer
        } catch {
            print("Could not create audio player for \(fileName).\(fileType): \(error.localizedDescription)")
        }
    }

    func playSound(_ soundType: SoundType) {
        guard let audioPlayer = audioPlayers[soundType], !audioPlayer.isPlaying else {
            print("Audio player for sound type \(soundType) not found or is already playing.")
            return
        }
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    func stopSound(_ soundType: SoundType) {
        audioPlayers[soundType]?.stop()
    }
    
    func setVolume(for soundType: SoundType, volume: Float) {
        guard let audioPlayer = audioPlayers[soundType] else {
            print("Audio player for sound type \(soundType) not found.")
            return
        }

        audioPlayer.volume = volume
    }
    
    func lowerVolume(for soundType: SoundType, by decibels: Float) {
        guard let audioPlayer = audioPlayers[soundType] else {
            print("Audio player for sound type \(soundType) not found.")
            return
        }

        let currentVolume = audioPlayer.volume
        let newVolume = max(currentVolume - decibels, 0.0)
        audioPlayer.volume = newVolume
    }

    func resetVolume(for soundType: SoundType) {
        guard let audioPlayer = audioPlayers[soundType] else {
            print("Audio player for sound type \(soundType) not found.")
            return
        }

        audioPlayer.volume = 1.0
    }
    func getAudioDuration(for soundType: SoundType) -> TimeInterval? {
        guard let audioPlayer = audioPlayers[soundType] else {
            print("Audio player for sound type \(soundType) not found.")
            return nil
        }
        
        return audioPlayer.duration
    }
    
    private func updateVolume() {
        let volume: Float = isMuted ? 0 : 1
        audioPlayers.values.forEach { $0.volume = volume }
    }
}
