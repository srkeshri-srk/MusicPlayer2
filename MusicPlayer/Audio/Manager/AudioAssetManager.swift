//
//  AudioAssetManager.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 22/10/23.
//

import Foundation

protocol Buildable {
    static func build() -> Self
}


final class AudioAssetManager {
    private(set) var asset: [URL]?
    
    init(asset: [URL]) {
        self.asset = asset
    }
}

//Builder Function
extension AudioAssetManager: Buildable {
    static func build() -> AudioAssetManager {
        AudioAssetManager(asset: Song.allAssets)
    }
}

private extension Song {
    static var allAssets: [URL] {
        Song.allCases.lazy.compactMap({ Bundle.main.url(forResource: $0.rawValue, withExtension: "mp3") })
    }
}
