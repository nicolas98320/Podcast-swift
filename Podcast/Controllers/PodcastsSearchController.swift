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
  
  var timer: Timer?
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    podcasts = []
    tableView.reloadData()
    
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
      APIService.shared.fetchPodcasts(searchText: searchText) { podcasts in
        self.podcasts = podcasts
        self.tableView.reloadData()
      }
    })
  }

  
  //MARK:- Setup PodcastsSearchController
  
  fileprivate func setupSearchBar() {
    definesPresentationContext = true
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
  
  var podcastSearchView = PodcastsSearchingView.viewFromNib
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return podcastSearchView
  }
  
  //MARK:- Variable height support
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 132
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return self.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
  }
  
}


