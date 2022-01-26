import UIKit

struct GifAPIClient: Clientable {
  
  func fetch<T>(url: BackendURL, completion: @escaping (Result<T?, Error>) -> ()) where T : Decodable, T : Encodable {
    switch url {
      case .feed:
        load(url: url.rawValue, completion: completion)
    }
  }
  
  private func load<T>(url: String, completion: @escaping (Result<T?, Error>) -> ()) where T : Decodable, T : Encodable {
    guard let webUrl = URL(string: url) else {
      let errorMessage = "Url could not be created from: \(url)"
      safePrint(errorMessage)
      let error = NSError(domain: errorMessage, code: ErrorCode.safeUnwrap.rawValue, userInfo: nil)
      completion(.failure(error))
      return
    }
    let session = URLSession.shared.dataTask(with: webUrl) { (data, response, error) in
      if let error = error {
        safePrint(error.localizedDescription)
        completion(.failure(error))
        return
      }
      if let data = data {
        let decoder = JSONDecoder()
        let results = try? decoder.decode(T.self, from: data)
        completion(.success(results))
      } else {
        completion(.success(nil))
      }
    }
  }
  
}

enum BackendURL: String {
  case feed = ""
}
