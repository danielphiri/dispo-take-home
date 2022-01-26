import Foundation
enum Constants {}

extension Constants {
  // Get an API key from https://developers.giphy.com/dashboard/
  static let giphyApiKey = ProcessInfo.processInfo.environment["API_KEY"]
}
