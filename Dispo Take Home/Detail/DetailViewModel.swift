//
//  DetailViewModel.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/27/22.
//

import Foundation

final class DetailViewModel {
  
  private let searchResult : SearchResult
  private let client       : GifAPIClient<GifDetails>
  private let model        : Observable<GifDetails>
  
  init(searchResult: SearchResult, client: GifAPIClient<GifDetails>, model: Observable<GifDetails>) {
    self.searchResult = searchResult
    self.client       = client
    self.model        = model
    load()
  }
  
  private func load() {
    client.fetch(url: .gifInfo, appendingPath: "\(searchResult.id)", parameters: [:]) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .failure(let error):
          safePrint(error)
          #warning("TODO: Handle Error case")
        case .success(let info):
          safePrint(info)
          if let info = info {
            self.model.value = info
          } else {
            #warning("TODO: Handle no results case")
          }
      }
    }
  }
  
}
