
import Foundation

class PostCommentProvider {
    func postComment(gistId: String, comment: String, successHandler: @escaping (_ response: GistComment) -> Void,
                       errorHandler: @escaping (_ error: String) -> Void) {
        
        NetworkManager.makeRequest(GistDemoHttpRouter.postComment(gistId: gistId, comment: comment), message: Constant.processing(), showProgress: true).onSuccess { (response: GistComment) in
            successHandler(response)
            }.onFailure { (error) in
                switch error {
                case .errorString(let errorJsonString):
                    if let errorJsonString = errorJsonString {
                        if let errorResponse = ErrorResponse(JSONString: errorJsonString) {
                            if let error = errorResponse.error {
                                if error == ErrorMessage.NotFound {
                                    errorHandler(AlertMessage.InValidQRCode)
                                }
                                else {
                                    errorHandler(AlertMessage.SomethingWentWrong)
                                }
                            }
                        }
                    }
                default:
                    errorHandler(AlertMessage.SomethingWentWrong)
                    break
                }
        }
    }
}
