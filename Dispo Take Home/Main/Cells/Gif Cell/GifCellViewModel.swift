//
//  GifCellViewModel.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import Foundation

final class GifCellViewModel  {
  
  var model: Observable<GifObject>
  
  init(model: Observable<GifObject>) {
    self.model = model
  }
  
}
