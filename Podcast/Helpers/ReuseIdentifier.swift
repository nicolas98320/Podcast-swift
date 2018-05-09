//
//  ReuseIdentifier.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 25/4/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation
import UIKit

protocol ReuseIdentifier {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifier {
  
  /// Return a suggested name that can be used as an cellIdentifier.
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
}

extension UIView: ReuseIdentifier {}

