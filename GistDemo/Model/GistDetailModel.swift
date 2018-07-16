
import Foundation
import ObjectMapper

class GistDetailModel: Mappable {
    
    var url: String?
    var files: [String : Any]?
    
    required init?(map: Map) {
        
    }
    // Mappable
    func mapping(map: Map) {
        url <- map["url"]
        files <- map["files"]
    }
}


