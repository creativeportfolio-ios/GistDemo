
import Foundation
import Alamofire
import ObjectMapper

public enum GistDemoHttpRouter: URLRequestConvertible {
    case getGistList(gistId: String)
    case getGistComment(gistId: String)
    
    static var OAuthToken: String?

    var method: Alamofire.HTTPMethod {
        switch self {
        case .getGistList,
             .getGistComment:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getGistList(let gistId):
            return gistId
        case .getGistComment(let gistId):
            return "\(gistId)/comments"
        }
    }
    
    var jsonParameters: [String: Any]? {
        switch self {
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
        case .getGistList,
             .getGistComment:
            return try URLEncoding.queryString.encode(urlRequest, with: self.urlParameters)
        }
    }
}
