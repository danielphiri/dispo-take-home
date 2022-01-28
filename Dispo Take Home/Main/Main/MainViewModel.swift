//
//  MainViewModel.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import Foundation

final class MainViewModel {
  
  let client : GifAPIClient<APIListResponse>
  var model  : Observable<APIListResponse>
  var state  : Observable<ViewDataState>
  
  init(
    model  : Observable<APIListResponse>,
    client : GifAPIClient<APIListResponse>,
    state  : Observable<ViewDataState>
  ) {
    self.model  = model
    self.state  = state
    self.client = client
    fetchTrending()
  }
  
  func search(text: String) {
    if text == "" {
      fetchTrending()
      return
    }
    client.fetch(
      url           : .search,
      appendingPath : nil,
      parameters    : ["q": text]
    ) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .failure(let error):
          safePrint("Error happened: \(error.localizedDescription)")
          self.state.value = .error
        case .success(let value):
          guard let value = value else {
            safePrint("No data returned")
            self.state.value = .emptyResults
            return
          }
          self.model.value = value
          self.state.value = .displaying
      }
    }
  }
  
  private func fetchTrending() {
    state.value = .loading
    client.fetch(
      url           : .trending,
      appendingPath : nil,
      parameters    : ["rating": "pg"]
    ) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .failure(let error):
          safePrint("Error happened: \(error.localizedDescription)")
          self.state.value = .error
        case .success(let value):
          guard let value = value else {
            safePrint("No data returned")
            self.state.value = .emptyResults
            return
          }
          self.model.value = value
          self.state.value = .displaying
      }
    }
  }
  
}
