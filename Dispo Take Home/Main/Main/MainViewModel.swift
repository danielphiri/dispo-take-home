//
//  MainViewModel.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import Foundation

final class MainViewModel {
  
  let client = GifAPIClient()
  var model: Observable<APIListResponse>
  
  init(model: Observable<APIListResponse>) {
    self.model = model
  }
  
}
