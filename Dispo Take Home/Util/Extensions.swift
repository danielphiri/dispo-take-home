//
//  Extensions.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import UIKit

extension UIColor {
  
  public static var systemBlack: UIColor = {
    if #available(iOS 13, *) {
      return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
          return UIColor.white
        } else {
          return UIColor.black
        }
      }
    } else {
      /// Return a fallback color for iOS 12 and lower.
      return UIColor.black
    }
  }()
  
}
