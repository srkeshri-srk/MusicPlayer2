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
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var startingTimeLabel: UILabel!
    @IBOutlet weak var endingTimeLabel: UILabel!
    
    var audio = Audio()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureUI()
        stopPlayerForcely()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopPlayerForcely()
    }
    
    private func setupUI() {
        slider.thumbTintColor = .clear
        slider.value = 0.0
    }
    
    private func configureUI() {
        audio.getInfo(at: audio.indexPath.row, completion: { [weak self] info in
            if let weakSelf = self {
                weakSelf.titleLabel.text = info.title
                weakSelf.artistLabel.text = info.artist
                weakSelf.artworkImageView.image = UIImage(data: info.artwork)
            }
        })
        
        audio.getDuration(at: audio.indexPath.row) { [weak self] timeInSec in
            if let weakSelf = self {
                DispatchQueue.main.async {
                    weakSelf.slider.value = 0.0
                    weakSelf.slider.maximumValue = timeInSec/60
                    weakSelf.startingTimeLabel.text = "00:00"
                    weakSelf.endingTimeLabel.text = String(format: "%.2f", timeInSec/60)
                }
            }
        }
    }
    
    private func stopPlayerForcely() {
        audio.stopSong()
        playerStateButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
    }
    
    private func playerStateToggle() {
        if audio.playerState {
            audio.stopSong()
            playerStateButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        } else {
            audio.playSong()
            playerStateButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }
    
    @IBAction func playerStateButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            self.playerStateToggle()
        }
    }
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        if audio.indexPath.row > 0 {
            audio.indexPath.row -= 1
            configureUI()
        }
    }
    
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        if audio.indexPath.row < audio.count - 1 {
            audio.indexPath.row += 1
            configureUI()
        }
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        print(sender.value)
    }
    
}
