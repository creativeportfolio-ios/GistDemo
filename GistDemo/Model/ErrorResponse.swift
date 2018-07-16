
import ObjectMapper
import NetworkExtension

class ErrorResponse: Mappable {
    var error: String!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        error <- map["message"]
    }
}
