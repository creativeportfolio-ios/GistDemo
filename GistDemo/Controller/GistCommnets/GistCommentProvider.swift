
import Foundation
import ObjectMapper

class GistCommentProvider {
    func getGistComments(gistId: String, showProgress:Bool, successHandler: @escaping (_ response: GistCommentModel?) -> Void,
                         errorHandler: @escaping (_ error: String) -> Void) {
        
        NetworkManager.makeJSONObjectArrayRequest(GistDemoHttpRouter.getGistComment(gistId: gistId), message: Constant.processing(), showProgress: showProgress)
            .onSuccess { (response: [NSDictionary]) in
                if response.count > 0 {
                    let gistJSON = ["data": response]
                    if let gistCommentModel = Mapper<GistCommentModel>().map(JSON: gistJSON) {
                        successHandler(gistCommentModel)
                    } else {
                        successHandler(nil)
                    }
                }
                else {
                    successHandler(nil)
                }
            }
            .onFailure { (error) in
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
