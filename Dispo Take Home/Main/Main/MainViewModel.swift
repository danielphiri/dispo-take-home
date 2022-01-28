//
//  MainViewModel.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import Foundation

final class MainViewModel {
  
  let client = GifAPIClient<APIListResponse>()
  var model  : Observable<APIListResponse>
  
  init(model: Observable<APIListResponse>) {
    self.model = model
    fetchTrending()
  }
  
  func search(text: String) {
    if text == "" {
      fetchTrending()
      return
    }
    client.fetch(url: .search, appendingPath: nil, parameters: ["q": text]) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .failure(let error):
          safePrint("Error happened: \(error.localizedDescription)")
          #warning("TODO: Handle error case")
        case .success(let value):
          guard let value = value else {
            safePrint("No data returned")
            #warning("TODO: Handle no data case")
            return
          }
          self.model.value = value
      }
    }
  }
  
  private func fetchTrending() {
    client.fetch(url: .trending, appendingPath: nil, parameters: ["rating": "pg"]) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .failure(let error):
          safePrint("Error happened: \(error.localizedDescription)")
          #warning("TODO: Handle error case")
        case .success(let value):
          guard let value = value else {
            safePrint("No data returned")
            #warning("TODO: Handle no data case")
            return
          }
          self.model.value = value
      }
    }
  }
  
}
