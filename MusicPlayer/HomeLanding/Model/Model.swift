//
//  Model.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 16/10/23.
//

import Foundation

enum Song: String, CaseIterable {
    case song1 = "HuaMainAnimal"
    case song2 = "AtrangiKissa"
    case song3 = "ChaleyaJawan"
    case song4 = "JaanaHaiTohJa"
    case song5 = "MannLaage"
    case song6 = "SanuEkPal"
    case song7 = "UnkiAadatSi"
}

enum MP3Error: Error {
    case fileNotFound
}

struct SongInfoDetails {
    let title: String
    let artist: String
    let artwork: Data
}

