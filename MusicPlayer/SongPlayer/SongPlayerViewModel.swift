//
//  SongPlayerViewModel.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 22/10/23.
//

import Foundation


final class SongPlayerViewModel {
    let audioAsset: AudioAssetManager
    var indexPath: IndexPath
    
    var count: Int {
        return audioAsset.asset?.count ?? 0
    }
    
    init(audioAsset: AudioAssetManager) {
        self.audioAsset = audioAsset
        self.indexPath = IndexPath(row: 0, section: 0)
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
}


extension SongPlayerViewModel: Buildable {
    static func build() -> SongPlayerViewModel {
        SongPlayerViewModel(audioAsset: .build())
    }
}
