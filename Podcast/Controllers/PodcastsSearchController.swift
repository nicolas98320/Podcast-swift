//
//  PodcastsSearchController.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 25/4/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
  
  var podcasts: [Podcast] = []
  
  let searchController = UISearchController(searchResultsController: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchBar()
    setupTableView()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    APIService.shared.fetchPodcasts(searchText: searchText) { [weak self] podcasts in
      guard let `self` = self else { return }
      self.podcasts = podcasts
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  //MARK:- Setup PodcastsSearchController
  
  fileprivate func setupSearchBar() {
    self.definesPresentationContext = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
  }
  
  fileprivate func setupTableView() {
    tableView.register(PodcastTableViewCell.nib, forCellReuseIdentifier: PodcastTableViewCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
  }
  
  //MARK:- UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcasts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PodcastTableViewCell.reuseIdentifier, for: indexPath) as! PodcastTableViewCell
    cell.configure(podcasts[indexPath.row])
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let episodesViewController = EpisodesViewController()
    episodesViewController.podcast = podcasts[indexPath.row]
    navigationController?.pushViewController(episodesViewController, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "Please enter a Search Term"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    return label
  }
  
  //MARK:- Variable height support
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 132
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return self.podcasts.count > 0 ? 0 : 250
  }
  
}


