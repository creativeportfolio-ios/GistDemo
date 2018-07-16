
import Foundation

class QRCodeScannerProvider {
    func getGistDetail(gistId: String, successHandler: @escaping () -> Void,
                       errorHandler: @escaping (_ error: String) -> Void) {
        
        NetworkManager.makeRequest(GistDemoHttpRouter.getGistList(gistId: gistId), message: Constant.processing(), showProgress: true).onSuccess { (response: GistDetailModel) in
            successHandler()
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
