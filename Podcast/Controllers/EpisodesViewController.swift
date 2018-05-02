//
//  EpisodesViewController.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 2/5/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesViewController: UITableViewController {
  
  var episodes: [Episode] = []
  var podcast: Podcast? {
    didSet {
      navigationItem.title = podcast?.trackName
      fetchEpisodes()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
  }
  
  //MARK:- Setup EpisodesViewController
  
  fileprivate func setupTableView() {
    tableView.register(EpisodeTableViewCell.nib, forCellReuseIdentifier: EpisodeTableViewCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
  }
  
  fileprivate func fetchEpisodes() {
    guard let feedUrl = podcast?.feedUrl else { return }
    
    APIService.shared.fetchEpisodes(feedUrl: feedUrl) { [weak self] (episodes) in
      guard let `self` = self else { return }
      self.episodes = episodes
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  //MARK:- UITableView
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.reuseIdentifier, for: indexPath) as! EpisodeTableViewCell
    cell.configure(episodes[indexPath.row])
    return cell
  }
  
  //MARK:- Variable height support
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 134
  }

}

