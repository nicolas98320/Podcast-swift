//
//  EpisodeTableViewCell.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 2/5/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit
import Kingfisher

class EpisodeTableViewCell: UITableViewCell {

  @IBOutlet weak var episodeImageView: UIImageView!
  @IBOutlet weak var pubDateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  func configure(_ episode: Episode) {
    titleLabel.text = episode.title
    titleLabel.numberOfLines = 2

    descriptionLabel.text = episode.description
    descriptionLabel.numberOfLines = 2
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
    
    let secureImageUrl = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
    episodeImageView.kf.setImage(with: secureImageUrl)
  }
    
}
