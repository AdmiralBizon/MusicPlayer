//
//  TracksCollectionViewCell.swift
//  MusicPlayer
//
//  Created by Ilya on 19.04.2022.
//

import UIKit

class TracksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var trackCoverImageView: UIImageView!
    
    func configureCell(for track: Track) {
        trackCoverImageView.image = UIImage(named: track.imageName)
        trackCoverImageView.layer.cornerRadius = 20
        trackCoverImageView.layer.masksToBounds = true
    }
    
}
