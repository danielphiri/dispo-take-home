//
//  CellConfigurable.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import Foundation

protocol CellConfigurable: AnyObject {
  
  func setUp<T>(data: T)
  
}
