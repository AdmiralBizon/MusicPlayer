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
    var currentTrack: Track?
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
        
        guard let currentTrack = currentTrack else {
            showAlert()
            return
        }

        if player?.isPlaying == true {
            player?.stop()
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            return }
        
        playTrack(track: currentTrack)
        playButton.setBackgroundImage(UIImage(systemName: "stop.fill"), for: .normal)
        
    }
    
    func playTrack(track: Track) {
        
        let urlString = Bundle.main.path(forResource: track.fileName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else { return }

            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else { return }
            
            player.volume = volumeSlider.value
            player.play()
            
        } catch {
            print("Error occured")
        }
        
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "", message: "Please select track", preferredStyle: .alert)
        
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
        currentTrack = tracks[indexPath.item]
        currentTrackLabel.text = currentTrack?.title
    }
    
}
