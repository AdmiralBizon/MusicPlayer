//
//  TracksViewController.swift
//  MusicPlayer
//
//  Created by Ilya on 19.04.2022.
//

import UIKit
import AVFoundation

class TracksViewController: UIViewController {

    @IBOutlet weak var crossfadeLabel: UILabel!
    @IBOutlet weak var crossfadeSlider: UISlider!
    @IBOutlet weak var tracksCollectionView: UICollectionView!
    @IBOutlet weak var currentTrackLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var tracks: [Track] = []
    var currentTrackPosition = -1
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tracks = Track.getTracklist()
    }
    
    @IBAction func crossfadeSliderValueChanged(_ sender: UISlider) {
        crossfadeLabel.text = string(from: sender)
    }
    
    @IBAction func volumeLevelChanged(_ sender: UISlider) {
        player?.volume = sender.value
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        if currentTrackPosition == -1 {
            showAlert()
            return
        }

        if player?.isPlaying == true {
            player?.stop()
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            return
        }
        
        playTrack(track: tracks[currentTrackPosition])
        playButton.setBackgroundImage(UIImage(systemName: "stop.fill"), for: .normal)
        
    }
    
    func playTrack(track: Track, delay: Double = 0.0) {
        
        guard let trackFileURL = Bundle.main.path(forResource: track.fileName, ofType: "mp3") else {
            print("File not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

            player = try AVAudioPlayer(contentsOf: URL(string: trackFileURL)!)
            
            guard let player = player else { return }
            
            player.delegate = self
            player.volume = volumeSlider.value
            
            if delay > 0 {
                player.play(atTime: delay)
            } else {
                player.play()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "", message: "You need to select track before start playing", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func string(from slider: UISlider) -> String{
        String(format: "%.0f", slider.value)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TracksViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackCell", for: indexPath) as! TracksCollectionViewCell
        cell.configureCell(for: tracks[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let player = player, player.isPlaying {
            player.stop()
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        
        currentTrackPosition = indexPath.item
        currentTrackLabel.text = tracks[indexPath.item].title
    }
    
}

// MARK: - AVAudioPlayerDelegate

extension TracksViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if currentTrackPosition != tracks.count - 1 {
            currentTrackPosition += 1
        } else {
            currentTrackPosition = 0
        }
        
        let nextTrack = tracks[currentTrackPosition]
        
        tracksCollectionView.selectItem(at: IndexPath(item: currentTrackPosition, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        currentTrackLabel.text = tracks[currentTrackPosition].title
        
        playTrack(track: nextTrack, delay: player.deviceCurrentTime + Double(crossfadeSlider.value))
        
    }
    
}
