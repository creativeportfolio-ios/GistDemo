
import Foundation
import Alamofire
import ObjectMapper

public enum GistDemoHttpRouter: URLRequestConvertible {
    case getGistList(gistId: String)
    case getGistComment(gistId: String)
    case postComment(gistId: String, comment: String)
    
    static var OAuthToken: String?

    var method: Alamofire.HTTPMethod {
        switch self {
        case .getGistList,
             .getGistComment:
            return .get
        case .postComment:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getGistList(let gistId):
            return gistId
        case .getGistComment(let gistId),
             .postComment(let gistId, _):
            return "\(gistId)/comments"
        }
    }
    
    var jsonParameters: [String: Any]? {
        switch self {
        case .postComment(_, let comment):
            return ["body": comment]
        default:
            return nil
        }
    }
    
    var urlParameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var isHeader: Bool {
        switch self {
        case .postComment:
            return true
        default:
            return false
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = URL.init(string: Constant.baseUrl()+path)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        
        if self.isHeader {
            if let token = GistDemoHttpRouter.OAuthToken {
                let headers = ["Authorization": "token \(token)"]
                urlRequest.allHTTPHeaderFields = headers
            }
        }
        
        switch self {
        case .postComment:
            return try JSONEncoding.default.encode(urlRequest, with: self.jsonParameters)
        case .getGistList,
             .getGistComment:
            return try URLEncoding.queryString.encode(urlRequest, with: self.urlParameters)
        }
    }
}
