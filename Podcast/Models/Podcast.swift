//
//  Podcast.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 25/4/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation

class Podcast: NSObject, Decodable, NSCoding {
  
  var trackName: String?
  var artistName: String?
  var artworkUrl600: String?
  var trackCount: Int?
  var feedUrl: String?
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(trackName ?? "", forKey: "trackNameKey")
    aCoder.encode(artistName ?? "", forKey: "artistNameKey")
    aCoder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
    aCoder.encode(feedUrl ?? "", forKey: "feedKey")
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.trackName = aDecoder.decodeObject(forKey: "trackNameKey") as? String
    self.artistName = aDecoder.decodeObject(forKey: "artistNameKey") as? String
    self.artworkUrl600 = aDecoder.decodeObject(forKey: "artworkKey") as? String
    self.feedUrl = aDecoder.decodeObject(forKey: "feedKey") as? String
  }
  
}

struct SearchResults: Decodable {
  let resultCount: Int
  let results: [Podcast]
}

