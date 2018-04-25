//
//  PodcastTableViewCell.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 25/4/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit

class PodcastTableViewCell: UITableViewCell {
  
  func configure(_ podcast: Podcast) {
    textLabel?.text = "\(podcast.trackName)\n\(podcast.artistName)"
    textLabel?.numberOfLines = -1
    imageView?.image = #imageLiteral(resourceName: "appicon")
  }
  
}

