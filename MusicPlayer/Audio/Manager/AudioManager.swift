//
//  AudioManager.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 22/10/23.
//

import Foundation
import AVFoundation


enum AudioError: Error {
    case audioFileNotFound
    case cannotProcessDuration
}


//Singleton
final class AudioManager {
    static let shared = AudioManager()
    
    private var player = AVAudioPlayer()
    var url: URL?
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    private init() { }
    
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
    
    func getInfo(completion: @escaping (_ info: SongInfoDetails?) -> Void) {
        Task {
            guard let url = url, let metadata = await extractMetadata(from: AVURLAsset(url: url)) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                var title = String()
                var artist = String()
                var artworkData = Data()
                
                if let titleValue = metadata[.commonKeyTitle] as? String, let _title = titleValue.components(separatedBy: "-").first {
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
    
    func getDuration(completion: @escaping (_ timeInSec: Float) -> Void) {
        Task {
            guard let url = url else {
                completion(0.0)
                return
            }
            
            let asset = AVURLAsset(url: url)
            do {
                let duration = try await asset.load(.duration)
                let timeInSec = Float(CMTimeGetSeconds(duration))
                completion(timeInSec)
            } catch {
                //Handle for Error
                completion(0.0)
                print(AudioError.cannotProcessDuration)
            }
        }
    }
    
    private func loadAudio() {
        guard let url = url else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            //Handle for Error
            print(AudioError.audioFileNotFound)
        }
    }
    
    func playAudio() {
        stopAudio {
            self.loadAudio()
            self.player.play()
        }
    }
    
    func playAudio(at time: TimeInterval) {
        stopAudio {
            self.loadAudio()
            self.player.play(atTime: time)
        }
    }

    func stopAudio(completion: (() -> Void)? = nil) {
        if player.isPlaying {
            player.stop()
            completion?()
        } else {
            completion?()
        }
    }
    
}
