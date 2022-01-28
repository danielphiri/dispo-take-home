//
//  Observable.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import Foundation

final class Observable<T> {
  
  let valueObserver : ((T?) -> ())
  var value         : T? {
                        didSet {
                          DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.valueObserver(self.value)
                          }
                        }
                      }
  
  init(valueObserver: @escaping (T?) -> ()) {
    self.valueObserver = valueObserver
  }
  
}
