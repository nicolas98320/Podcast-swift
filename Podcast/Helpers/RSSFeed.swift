//
//  RSSFeed.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 2/5/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeed {
  
  func toEpisodes() -> [Episode] {
    let imageUrl = iTunes?.iTunesImage?.attributes?.href
    
    var episodes: [Episode] = []
    items?.forEach({ (feedItem) in
      var episode = Episode(feedItem: feedItem)
      
      if episode.imageUrl == nil {
        episode.imageUrl = imageUrl
      }
      
      episodes.append(episode)
    })
    return episodes
  }
  
}
