//
//  Episode.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 2/5/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
  let title: String
  let pubDate: Date
  let description: String
  var imageUrl: String?
  
  init(feedItem: RSSFeedItem) {
    self.title = feedItem.title ?? ""
    self.pubDate = feedItem.pubDate ?? Date()
    self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
    self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
  }
}
