//
//  Clientable.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import Foundation

protocol Clientable {
  func fetch<T: Codable>(url: BackendURL, completion: @escaping (Result<T?, Error>) -> ())
}

func safePrint(_ info: Any) {
  #if DEBUG
    print(info)
  #endif
}

enum ErrorCode: Int {
  case safeUnwrap = 501
}
