//
//  String.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 2/5/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation

extension String {
  func toSecureHTTPS() -> String {
    return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
  }
}
