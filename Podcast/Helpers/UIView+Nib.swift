//
//  UIView+Nib.swift
//  Podcast
//
//  Created by Nicolas Desormiere on 1/5/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  /// Return an UINib object from the nib file with the same name.
  class var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
  
  class var viewFromNib: UIView? {
    let views = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)
    let view = views![0] as! UIView
    return view
  }
  
}
