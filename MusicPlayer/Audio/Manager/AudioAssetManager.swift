//
//  AudioAssetManager.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 22/10/23.
//

import Foundation


final class AudioAssetManager {
    var asset: [URL]?
    
    init() {
        self.asset = Song.allCases.lazy.compactMap{ loadMP3Asset(file: $0.rawValue) }
    }
    
    private func loadMP3Asset(file: String) -> URL {
        if let mp3FilePath = Bundle.main.url(forResource: file, withExtension: "mp3") {
            return mp3FilePath
        } else {
            return URL(fileURLWithPath: "")
        }
    }
}
