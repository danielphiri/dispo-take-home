//
//  Clientable.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import Foundation

protocol Clientable {
  associatedtype T: Decodable
  func fetch(url: BackendURL, parameters: [String: String], completion: @escaping (Result<T?, Error>) -> ())
}

func safePrint(_ info: Any) {
  #if DEBUG
    print(info)
  #endif
}

enum ErrorCode: Int {
  case safeUnwrap = 501
}
