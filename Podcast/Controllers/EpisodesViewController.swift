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
    setupNavigationBarButtons()
    setupTableView()
  }
  
  //MARK:- Setup EpisodesViewController
  
  fileprivate func setupNavigationBarButtons() {
    let savedPodcasts = UserDefaults.standard.savedPodcasts()
    let hasFavorited = savedPodcasts.index(where: { $0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName }) != nil
    if hasFavorited {
      navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
    } else {
      navigationItem.rightBarButtonItems = [
        UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
      ]
    }
  }
  
  @objc fileprivate func handleSaveFavorite() {
    guard let podcast = self.podcast else { return }
    var listOfPodcasts = UserDefaults.standard.savedPodcasts()
    listOfPodcasts.append(podcast)
    let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
    UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    showBadgeHighlight()
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
  }
  
  fileprivate func showBadgeHighlight() {
    UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
  }
  
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
    let episode = self.episodes[indexPath.row]
    let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
    mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
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
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicatorView.color = .darkGray
    activityIndicatorView.startAnimating()
    return activityIndicatorView
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
      let episode = self.episodes[indexPath.row]
      UserDefaults.standard.downloadEpisode(episode: episode)
      APIService.shared.downloadEpisode(episode: episode)
    }
    return [downloadAction]
  }
  
  //MARK:- Variable height support
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 134
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return episodes.isEmpty ? 200 : 0
  }
  
}


