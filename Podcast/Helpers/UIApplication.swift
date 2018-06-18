//
//  UIApplication.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 18/6/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit

extension UIApplication {
  
  static func mainTabBarController() -> MainTabBarController? {    
    return shared.keyWindow?.rootViewController as? MainTabBarController
  }
  
}
