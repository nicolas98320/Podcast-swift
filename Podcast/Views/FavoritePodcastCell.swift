//
//  FavoritePodcastCell.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 21/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
  
  var podcast: Podcast! {
    didSet {
      nameLabel.text = podcast.trackName
      artistNameLabel.text = podcast.artistName
      
      let url = URL(string: podcast.artworkUrl600 ?? "")
      imageView.kf.setImage(with: url)
    }
  }
  
  let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
  let nameLabel = UILabel()
  let artistNameLabel = UILabel()
  
  fileprivate func stylizeUI() {
    nameLabel.text = "Podcast Name"
    nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    artistNameLabel.text = "Artist Name"
    artistNameLabel.font = UIFont.systemFont(ofSize: 14)
    artistNameLabel.textColor = .lightGray
  }
  
  fileprivate func setupViews() {
    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    
    let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistNameLabel])
    
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(stackView)
    
    stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    stylizeUI()
    setupViews()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


