//
//  HomeLandingViewController.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 17/10/23.
//

import UIKit

class HomeLandingViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    
    var homeLandingViewModel = HomeLandingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        title = "SRK's Music Player"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SongArtworkTableViewCell", bundle: nil), forCellReuseIdentifier: "SongArtworkTableViewCell")
    }
}

extension HomeLandingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeLandingViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SongArtworkTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SongArtworkTableViewCell", for: indexPath) as! SongArtworkTableViewCell
        homeLandingViewModel.getInfo(of: indexPath.row) { info in
            cell.configureUI(info: info)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row % 2 == 0 {
            homeLandingViewModel.playAudio(of: indexPath.row)
        } else {
            homeLandingViewModel.stopAudio()
        }
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "SongPlayer", bundle: nil)
//        let vc: SongPlayerViewController = storyboard.instantiateViewController(withIdentifier: "SongPlayerViewController") as! SongPlayerViewController
//        vc.audio = audio
//        vc.audio.indexPath = indexPath
//        self.present(vc, animated: true, completion: nil)
    }
}
