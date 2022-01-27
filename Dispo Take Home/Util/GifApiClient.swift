import UIKit

struct GifAPIClient<T: Decodable> : Clientable {
  
  func fetch(url: BackendURL, completion: @escaping (Result<T?, Error>) -> ()) {
    guard var components = URLComponents(string: url.rawValue) else {
      let errorMessage = "Url could not be created from: \(url)"
      safePrint(errorMessage)
      let error = NSError(domain: errorMessage, code: ErrorCode.safeUnwrap.rawValue, userInfo: nil)
      completion(.failure(error))
      return
    }
    components.queryItems = [
      URLQueryItem(name: "api_key", value: Constants.giphyApiKey)
    ]
    guard let webUrl = components.url else {
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
    
    session.resume()
  }
  
  private func load(url: String, completion: @escaping (Result<T?, Error>) -> ()) {
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
  case feed = "https://api.giphy.com/v1/gifs/trending"
}
