//
//  Track.swift
//  MusicPlayer
//
//  Created by Ilya on 19.04.2022.
//

import Foundation

struct Track {
    let title: String
    let fileName: String
    let imageName: String
    
    static func getTracklist() -> [Track] {
        let tracklist: [Track] = [
            Track(title: "Song #1", fileName: "Track1", imageName: "Song_logo"),
            Track(title: "Song #2", fileName: "Track2", imageName: "Song_logo")
        ]
        
        return tracklist
    }
    
}
