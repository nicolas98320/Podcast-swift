//
//  Podcast.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 25/4/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
  var trackName: String?
  var artistName: String?
}

struct SearchResults: Decodable {
  let resultCount: Int
  let results: [Podcast]
}
