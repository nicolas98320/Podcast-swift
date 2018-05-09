//
//  PlayerDetailsView.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 9/5/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit
import Kingfisher

class PlayerDetailsView: UIView {
  
  @IBOutlet weak var episodeImageView: UIImageView!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!

  func configure(_ episode: Episode) {
    titleLabel.text = episode.title
    authorLabel.text = episode.author
    guard let url = URL(string: episode.imageUrl ?? "") else { return }
    episodeImageView.kf.setImage(with: url)
  }
  
  @IBAction func handleDismiss(_ sender: Any) {
    self.removeFromSuperview()
  }
  
}
