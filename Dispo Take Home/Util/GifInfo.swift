import UIKit
import Foundation

struct GifInfo: Codable {
  var id: String
  var url: URL // Updated from gifUrl since it doesn't exist
  var title: String // Updated from text since it doesn't exist
//  var backgroundColor: UIColor?
  var source_tld: String
  var rating: String
  var images: Images
  
  struct Images: Codable {
    var fixed_height: Image
    
    struct Image: Codable {
      var url: URL
      var width: String
      var height: String
    }
  }
}


struct GifDetails: Codable {
  var data: GifInfo
}
