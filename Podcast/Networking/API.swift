//
//  API.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 30/4/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
  
  static let shared = APIService()
  
  func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
    let secureFeedUrl = feedUrl.toSecureHTTPS()
    guard let url = URL(string: secureFeedUrl) else { return }
    
    let parser = FeedParser(URL: url)
    parser?.parseAsync(result: { (result) in
      
      if let err = result.error {
        print("Failed to parse XML feed:", err)
        return
      }
      
      guard let feed = result.rssFeed else { return }
      
      let episodes = feed.toEpisodes()
      completionHandler(episodes)
    })
  }
  
  func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
    let parameters = ["term": searchText, "media": "podcast"]
    Alamofire
      .request(EndPoints.iTunesSearchURL , method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
      .responseData { (dataResponse) in
        
        if let err = dataResponse.error {
          print("iTunes search failed", err)
          return
        }
        
        guard let data = dataResponse.data else { return }
        do {
          let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
          completionHandler(searchResult.results)
          
        } catch let decodeErr {
          print("Failed to decode:", decodeErr)
        }
    }
  }
  
}
