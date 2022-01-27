import UIKit

struct GifAPIClient<T: Decodable> : Clientable {
  
  func fetch(url: BackendURL, parameters: [String: String], completion: @escaping (Result<T?, Error>) -> ()) {
    guard var components = URLComponents(string: url.rawValue) else {
      let errorMessage = "Url could not be created from: \(url)"
      safePrint(errorMessage)
      let error = NSError(domain: errorMessage, code: ErrorCode.safeUnwrap.rawValue, userInfo: nil)
      completion(.failure(error))
      return
    }
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "api_key", value: Constants.giphyApiKey)
    ]
    for parameter in parameters {
      queryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
    }
    components.queryItems = queryItems
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
  
}

enum BackendURL: String {
  case trending = "https://api.giphy.com/v1/gifs/trending"
}
