import UIKit

struct GifAPIClient<T: Decodable> : Clientable {
  
  func fetch(url: BackendURL, appendingPath: String?, parameters: [String: String], completion: @escaping (Result<T?, Error>) -> ()) {
    guard var components = URLComponents(string: "\(url.rawValue)\(appendingPath != nil ? "/\(appendingPath!)": "")") else {
      let errorMessage = "Url could not be created from: \(url.rawValue)\(appendingPath != nil ? "/\(appendingPath!)": "")"
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
        do {
          let decoder = JSONDecoder()
          let results = try decoder.decode(T.self, from: data)
          safePrint(webUrl)
          completion(.success(results))
        } catch DecodingError.dataCorrupted(let context) {
          print(context)
//          completion(.failure(context))
        } catch DecodingError.keyNotFound(let key, let context) {
          print("Key '\(key)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
          print(context)
          print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
          print("Value '\(value)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
          print("Type '\(type)' mismatch:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch {
          print("error: ", error)
          completion(.failure(error))
        }
      } else {
        completion(.success(nil))
      }
    }
    session.resume()
  }
  
}

enum BackendURL: String {
  case trending = "https://api.giphy.com/v1/gifs/trending"
  case search   = "https://api.giphy.com/v1/gifs/search"
  case gifInfo  = "https://api.giphy.com/v1/gifs"
}
