//
//  SongArtworkTableViewCell.swift
//  MusicPlayer
//
//  Created by Shreyansh Raj  Keshri on 17/10/23.
//

import UIKit

class SongArtworkTableViewCell: UITableViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak private var titlelabel: UILabel!
    @IBOutlet weak private var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func reset() {
        titlelabel.text = nil
        artistLabel.text = nil
        artworkImageView.image = nil
    }
    
    func configureUI(info: SongInfoDetails?) {
        guard let info else { return }
        reset()
        titlelabel.text = info.title
        artistLabel.text = info.artist
        artworkImageView.image = UIImage(data: info.artwork)
    }
}
