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
    @IBOutlet weak var artworkOuterView: UIView!
    
    
    var songPlayerViewModel = SongPlayerViewModel.build()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupPlayer()
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
        songPlayerViewModel.indexDecrement()
        configureUI()
        setupPlayer()
    }
    
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        songPlayerViewModel.indexIncrement()
        configureUI()
        setupPlayer()
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        print(sender.value)
        startingTimeLabel.text = String(format: "%.2f", sender.value)
        AudioManager.shared.playAudio(at: TimeInterval(sender.value))
    }
    
}

private extension SongPlayerViewController {
    func setupUI() {
        slider.thumbTintColor = .clear
        slider.value = 0.0
        artworkImageView.applyshadowWithCorner(containerView: artworkOuterView, cornerRadious: 8.0)
    }
    
    func configureUI() {
//        songPlayerViewModel.getInfo(of: songPlayerViewModel.getIndex) { [weak self] info in
//            guard let self = self else { return }
//            self.titleLabel.text = info?.title
//            self.artistLabel.text = info?.artist
//            self.artworkImageView.image = UIImage(data: info?.artwork ?? Data())
//        }
//        
//        songPlayerViewModel.getDuration(of: songPlayerViewModel.getIndex) { [weak self] timeInSec in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.slider.value = 0.0
//                self.slider.minimumValue = 0.0
//                self.slider.maximumValue = timeInSec/60
//                self.startingTimeLabel.text = "00:00"
//                self.endingTimeLabel.text = String(format: "%.2f", timeInSec/60)
//            }
//        }
        
        if songPlayerViewModel.getIndex == 0 {
            leftPlayButton.isEnabled = false
            rightPlayButton.isEnabled = true
        } else if songPlayerViewModel.getIndex == songPlayerViewModel.count - 1 {
            leftPlayButton.isEnabled = true
            rightPlayButton.isEnabled = false
        } else {
            leftPlayButton.isEnabled = true
            rightPlayButton.isEnabled = true
        }
    }
    
    func setupPlayer() {
        if let url = songPlayerViewModel.audioAsset.asset?[songPlayerViewModel.getIndex] {
            AudioManager.shared.setup(url)
            playPlayer()
        }
    }
    
    func stopPlayer() {
        AudioManager.shared.stopAudio()
    }
    
    func pausePlayer() {
        AudioManager.shared.pauseAudio()
        playerStateButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
    }
    
    func playPlayer() {
        AudioManager.shared.playAudio()
        playerStateButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
    }
    
    func playerStateToggle() {
        if AudioManager.shared.isPlaying {
            pausePlayer()
        } else {
            playPlayer()
        }
    }
}
