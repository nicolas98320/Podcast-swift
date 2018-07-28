//
//  UserDefaults.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 28/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation

extension UserDefaults {
  
  static let favoritedPodcastKey = "favoritedPodcastKey"
  
  func savedPodcasts() -> [Podcast] {
    guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
    guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Podcast] else { return [] }
    return savedPodcasts
  }
  
  func deletePodcast(podcast: Podcast) {
    let podcasts = savedPodcasts()
    let filteredPodcasts = podcasts.filter { (p) -> Bool in
      return p.trackName != podcast.trackName && p.artistName != podcast.artistName
    }
    let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
    UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
  }
  
}


