
import Foundation
import ObjectMapper

class GistCommentModel: Mappable {
    
    var data: [GistComment]?
    
    required init?() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        data <- map["data"]
    }
}

class GistComment: Mappable {
    
    var comment: String?
    var createdDate: String?
    var profileUrl: String?
    var userName: String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        comment <- map["body"]
        createdDate <- map["created_at"]
        profileUrl <- map["user.avatar_url"]
        userName <- map["user.login"]
    }
}
