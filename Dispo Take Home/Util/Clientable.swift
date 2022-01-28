//
//  Clientable.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import Foundation

protocol Clientable {
  
  associatedtype T: Decodable
  
  /* Parameters
     url           : The base url to be used for fetching the data
     appendingPath : An optional parameter to indicate whether a path needs to be appended
                     to the base url. The path should not include the forward slash separator ('/').
     parameters    : Any additional parameters to be added to the query. A call with empty
                     parameters should pass in an empty array declaration ([])
     completion    : The handler to be called after the network call is done.
   */
  func fetch(
    url           : BackendURL,
    appendingPath : String?,
    parameters    : [String: String],
    completion    : @escaping (Result<T?, Error>) -> ()
  )
  
}

func safePrint(_ info: Any) {
  #if DEBUG
    print(info)
  #endif
}

enum ErrorCode: Int {
  case safeUnwrap = 501
}
