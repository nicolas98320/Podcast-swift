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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let window = UIApplication.shared.keyWindow
    let playerDetailsView = Bundle.main.loadNibNamed(PlayerDetailsView.reuseIdentifier, owner: self, options: nil)?.first as! PlayerDetailsView
    playerDetailsView.episode = episodes[indexPath.row]
    playerDetailsView.frame = view.frame
    window?.addSubview(playerDetailsView)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return episodes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.reuseIdentifier, for: indexPath) as! EpisodeTableViewCell
    cell.episode = episodes[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    activityIndicatorView.color = .darkGray
    activityIndicatorView.startAnimating()
    return activityIndicatorView
  }
  
  //MARK:- Variable height support
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 134
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return episodes.isEmpty ? 200 : 0
  }

}

