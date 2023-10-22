//
//  SongPlayerViewController.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 17/10/23.
//

import UIKit

class SongPlayerViewController: UIViewController {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playerStateButton: UIButton!
    @IBOutlet weak var leftPlayButton: UIButton!
    @IBOutlet weak var rightPlayButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var startingTimeLabel: UILabel!
    @IBOutlet weak var endingTimeLabel: UILabel!
    
    var songPlayerViewModel = SongPlayerViewModel.build()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureUI()
        playPlayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopPlayer()
    }
    
    @IBAction func playerStateButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            self.playerStateToggle()
        }
    }
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        if songPlayerViewModel.indexPath.row > 0 {
            songPlayerViewModel.indexPath.row -= 1
            playPlayer()
            configureUI()
        }
    }
    
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        if songPlayerViewModel.indexPath.row < songPlayerViewModel.count - 1 {
            songPlayerViewModel.indexPath.row += 1
            playPlayer()
            configureUI()
        }
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        print(sender.value)
    }
    
}

private extension SongPlayerViewController {
    func setupUI() {
        slider.thumbTintColor = .clear
        slider.value = 0.0
    }
    
    func configureUI() {
        songPlayerViewModel.getInfo(of: songPlayerViewModel.indexPath.row) { [weak self] info in
            guard let self = self else { return }
            self.titleLabel.text = info?.title
            self.artistLabel.text = info?.artist
            self.artworkImageView.image = UIImage(data: info?.artwork ?? Data())
        }
        
        songPlayerViewModel.getDuration(of: songPlayerViewModel.indexPath.row) { [weak self] timeInSec in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.slider.value = 0.0
                self.slider.maximumValue = timeInSec/60
                self.startingTimeLabel.text = "00:00"
                self.endingTimeLabel.text = String(format: "-%.2f", timeInSec/60)
            }
        }
        
        if songPlayerViewModel.indexPath.row == 0 {
            leftPlayButton.isEnabled = false
            rightPlayButton.isEnabled = true
        } else if songPlayerViewModel.indexPath.row == songPlayerViewModel.count - 1{
            leftPlayButton.isEnabled = true
            rightPlayButton.isEnabled = false
        } else {
            leftPlayButton.isEnabled = true
            rightPlayButton.isEnabled = true
        }
    }
    
    func stopPlayer() {
        AudioManager.shared.stopAudio()
        playerStateButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
    }
    
    func playPlayer() {
        if let url = songPlayerViewModel.audioAsset.asset?[songPlayerViewModel.indexPath.row] {
            AudioManager.shared.setup(url)
            AudioManager.shared.playAudio()
        }
        playerStateButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
    }
    
    func playerStateToggle() {
        if AudioManager.shared.isPlaying {
            stopPlayer()
        } else {
            playPlayer()
        }
    }
}
