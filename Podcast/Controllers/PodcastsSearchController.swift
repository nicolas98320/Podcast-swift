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
      guard let `self` = self else {return}
      self.podcasts = podcasts
      self.tableView.reloadData()
    }
  }
  
  //MARK:- Setup PodcastsSearchController
  
  fileprivate func setupSearchBar() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
  }
  
  fileprivate func setupTableView() {
    tableView.register(PodcastTableViewCell.self, forCellReuseIdentifier: PodcastTableViewCell.reuseIdentifier)
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
}

