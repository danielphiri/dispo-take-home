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
  var state                : Observable<ViewDataState>
  
  init(
    searchResult : SearchResult,
    client       : GifAPIClient<GifDetails>,
    model        : Observable<GifDetails>,
    state        : Observable<ViewDataState>
  ) {
    self.searchResult = searchResult
    self.client       = client
    self.model        = model
    self.state        = state
    load()
  }
  
  private func load() {
    state.value = .loading
    client.fetch(
      url           : .gifInfo,
      appendingPath : "\(searchResult.id)",
      parameters    : [:]
    ) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .failure(let error):
          safePrint(error)
          self.state.value = .error
        case .success(let info):
          safePrint(info)
          if let info = info {
            self.model.value = info
            self.state.value = .displaying
          } else {
            self.state.value = .emptyResults
          }
      }
    }
  }
  
}
