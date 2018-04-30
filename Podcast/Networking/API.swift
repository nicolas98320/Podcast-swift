//
//  API.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 30/4/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
  
  //singleton
  static let shared = APIService()
    
  func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
    let parameters = ["term": searchText, "media": "podcast"]
    Alamofire
      .request(EndPoints.iTunesSearchURL , method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
      .responseData { (dataResponse) in
      
      if let err = dataResponse.error {
        print("Failed to contact yahoo", err)
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






