import UIKit

struct GifAPIClient<T: Decodable> : Clientable {
  
  func fetch(
    url           : BackendURL,
    appendingPath : String?,
    parameters    : [String: String],
    completion    : @escaping (Result<T?, Error>) -> ()
  ) {
    guard var components = URLComponents(string: "\(url.rawValue)\(appendingPath != nil ? "/\(appendingPath!)": "")") else {
      let errorMessage   = """
                            Url could not be created from:
                            \(url.rawValue)\(appendingPath != nil ?
                            "/\(appendingPath!)": "")
                          """
      let error          = NSError(
                            domain   : errorMessage,
                            code     : ErrorCode.safeUnwrap.rawValue,
                            userInfo : nil
                          )
      safePrint(errorMessage)
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
    guard let webUrl      = components.url else {
      let errorMessage    = "Url could not be created from: \(url)"
      let error           = NSError(
                            domain   : errorMessage,
                            code     : ErrorCode.safeUnwrap.rawValue,
                            userInfo : nil
                          )
      safePrint(errorMessage)
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
          safePrint(context)
        } catch DecodingError.keyNotFound(let key, let context) {
          safePrint("Key '\(key)' not found: \(context.debugDescription)")
          safePrint("codingPath: \(context.codingPath)")
        } catch DecodingError.valueNotFound(let value, let context) {
          safePrint("Value '\(value)' not found: \(context.debugDescription)")
          safePrint("codingPath: \(context.codingPath)")
        } catch DecodingError.typeMismatch(let type, let context) {
          safePrint("Type '\(type)' mismatch: \(context.debugDescription)")
          safePrint("codingPath: \(context.codingPath)")
        } catch {
          safePrint("error: \(error)")
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
