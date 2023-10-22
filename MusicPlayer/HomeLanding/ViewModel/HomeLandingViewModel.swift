//
//  HomeLandingViewModel.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 22/10/23.
//

import Foundation


final class HomeLandingViewModel {
    let audioAsset: AudioAssetManager
    
    init(audioAsset: AudioAssetManager) {
        self.audioAsset = audioAsset
    }
    
    var count: Int {
        return audioAsset.asset?.count ?? 0
    }
    
    func getInfo(of index: Int, completion: @escaping (_ info: SongInfoDetails?) -> Void) {
        if let url = audioAsset.asset?[index] {
            AudioManager.shared.setup(url)
            AudioManager.shared.getInfo(completion: completion)
        }
    }
    
    func getDuration(of index: Int, completion: @escaping (_ timeInSec: Float) -> Void) {
        if let url = audioAsset.asset?[index] {
            AudioManager.shared.setup(url)
            AudioManager.shared.getDuration(completion: completion)
        }
    }
    
    func playAudio(of index: Int) {
        if let url = audioAsset.asset?[index] {
            AudioManager.shared.setup(url)
            AudioManager.shared.playAudio()
        }
    }
    
    func playAudio(of index: Int, at time: TimeInterval) {
        if let url = audioAsset.asset?[index] {
            AudioManager.shared.setup(url)
            AudioManager.shared.playAudio(at: time)
        }
    }
    
    func stopAudio() {
        if AudioManager.shared.isPlaying {
            AudioManager.shared.stopAudio()
        }
    }
}

extension HomeLandingViewModel: Buildable {
    static func build() -> HomeLandingViewModel {
        HomeLandingViewModel(audioAsset: .build())
    }
}
