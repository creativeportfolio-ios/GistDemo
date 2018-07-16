
import Foundation
import BrightFutures
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import RappleProgressHUD

enum NetworkError: Error {
    case notFound
    case unauthorized
    case forbidden
    case nonRecoverable
    case errorString(String?)
    case unprocessableEntity(String?)
    case other
}

struct NetworkManager {
    
    static let networkQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "com.techflitter").networking-queue", attributes: .concurrent)
    
    static func makeRequest<T: Mappable>(_ urlRequest: URLRequestConvertible, message: String, showProgress: Bool,
                                         showLog: Bool = true) ->
        Future<T, NetworkError> {
            let promise = Promise<T, NetworkError>()
            if (showProgress == true) {
                DispatchQueue.main.async() {
                        let attributes = RappleActivityIndicatorView.attribute(style: RappleStyle.apple)
                        RappleActivityIndicatorView.startAnimatingWithLabel(message, attributes: attributes)
                    }
            }
            
            let request = Alamofire.request(urlRequest)
                .validate()
                .responseObject(queue: networkQueue) { (response: DataResponse<T>)-> Void in
                    if (showLog) {
                        print("\nResponse: \(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)\n")
                    }
                    if (showProgress == true) {
                        DispatchQueue.main.async() {
                            RappleActivityIndicatorView.stopAnimation()
                        }
                    }
                    switch response.result {
                    case .success:
                        promise.success(response.result.value!)
                        
                    case .failure
                        where response.response?.statusCode == 400:
                        var jsonData: String?
                        if let data = response.data {
                            jsonData = String(data: data, encoding: .utf8)
                        }
                        promise.failure(.errorString(jsonData))
                        
                    case .failure
                        where response.response?.statusCode == 401:
                        promise.failure(.unauthorized)
                        
                    case .failure
                        where response.response?.statusCode == 403:
                        promise.failure(.forbidden)
                        
                    case .failure
                        where response.response?.statusCode == 404:
                        var jsonData: String?
                        if let data = response.data {
                            jsonData = String(data: data, encoding: .utf8)
                        }
                        promise.failure(.errorString(jsonData))

                    case .failure
                        where response.response?.statusCode == 422:
                        var jsonData: String?
                        
                        if let data = response.data {
                            jsonData = String(data: data, encoding: .utf8)
                        }
                        promise.failure(.unprocessableEntity(jsonData))
                        
                    case .failure
                        where response.response?.statusCode == 500:
                        promise.failure(.nonRecoverable)
                        
                    case .failure:
                        promise.failure(.other)
                    }
            }
            
            if (showLog) {
                debugPrint(request)
            }
            
            return promise.future
    }
}
