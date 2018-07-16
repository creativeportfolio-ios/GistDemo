
import Foundation

protocol QRCodeScannerView: class {
    func finishGetGistDetailWithSuccess()
    func finishGetGistDetailWithError(error: String)
}
