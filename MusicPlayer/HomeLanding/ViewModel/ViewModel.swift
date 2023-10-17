//
//  ViewModel.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 16/10/23.
//

import UIKit
import AVFoundation

class Audio {
    //MARK: - variables
    private var player = AVAudioPlayer()
    private var asset: [URL]?
    var indexPath = IndexPath(row: 0, section: 0)
    
    var count: Int {
        return asset?.count ?? 0
    }
    
    var playerState: Bool {
        return player.isPlaying
    }

    init() {
        self.asset = Song.allCases.lazy.map{ loadMP3Asset(file: $0.rawValue) }
    }
    
    public func getInfo(at index: Int, completion: @escaping (_ info: SongInfoDetails) -> Void) {
        Task {
            if let url = asset?[index], let metadata = await extractMetadata(from: AVURLAsset(url: url)) {
                DispatchQueue.main.async {
                    var title = String()
                    var artist = String()
                    var artworkData = Data()
                    
                    if let _title = metadata[.commonKeyTitle] as? String {
                        title = _title
                    }
                    
                    if let _artist = metadata[.commonKeyArtist] as? String {
                        artist = _artist
                    }
                    
                    if let _artworkData = metadata[.commonKeyArtwork] as? Data {
                        artworkData = _artworkData
                    }
                    
                    completion(SongInfoDetails(title: title, artist: artist, artwork: artworkData))
                }
            }
        }
    }
    
    public func playSong() {
        loadSound()
        player.play()
    }
    
    public func playSong(at time: TimeInterval) {
        loadSound()
        player.play(atTime: time)
    }
    
    public func stopSong() {
        if player.isPlaying {
            player.stop()
        }
    }
}


//MARK: - Private Methods
extension Audio {
    private func loadMP3Asset(file: String) -> URL {
        if let mp3FilePath = Bundle.main.url(forResource: file, withExtension: "mp3") {
            return mp3FilePath
        } else {
            return URL(fileURLWithPath: "")
        }
    }
    
    private func extractMetadata(from asset: AVURLAsset) async -> [AVMetadataKey : Any]? {
        do {
            let metadata = try await AVMetadataItem.metadataItems(from: asset.load(.metadata), withKey: nil, keySpace: AVMetadataKeySpace.common)
            
            var metadataDict: [AVMetadataKey : Any] = [:]
            for item in metadata {
                if let commonKey = item.commonKey, let value = try await item.load(.value) {
                    metadataDict[commonKey] = value
                }
            }
            
            return metadataDict.isEmpty ? nil : metadataDict
        } catch {
            return nil
        }
    }
    
    private func loadSound() {
        do {
            if let url = asset?[indexPath.row] {
                player = try AVAudioPlayer(contentsOf: url)
            }
        } catch { }
    }
}
