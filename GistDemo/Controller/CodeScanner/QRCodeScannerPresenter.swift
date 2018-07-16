
import Foundation

class QRCodeScannerPresenter {
    
    let provider: QRCodeScannerProvider
    weak private var qrCodeScannerView: QRCodeScannerView?
    
    // MARK: - Initialization & Configuration
    init(provider: QRCodeScannerProvider) {
        self.provider = provider
    }
    
    func attachView(view: QRCodeScannerView?) {
        guard let view = view else { return }
        qrCodeScannerView = view
    }
    
    func getGistDetail(gistId: String) {
        provider.getGistDetail(gistId: gistId, successHandler: {
            self.qrCodeScannerView?.finishGetGistDetailWithSuccess()
        }, errorHandler: { (error) in
            self.qrCodeScannerView?.finishGetGistDetailWithError(error: error)
        })
    }
}
