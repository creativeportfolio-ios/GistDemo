
import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController {

    @IBOutlet weak var scannerView: UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var alert: UIAlertController!
    lazy var gistId: String = ""
    
    var presenter: QRCodeScannerPresenter = QRCodeScannerPresenter(provider: QRCodeScannerProvider())
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attachView(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getCamaraPermision()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension QRCodeScannerViewController {
    
    func getCamaraPermision() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == true {
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
                
                do {
                    let input = try AVCaptureDeviceInput(device: captureDevice!)
                    self.captureSession = AVCaptureSession()
                    self.captureSession?.addInput(input)
                    let captureMetadataOutput = AVCaptureMetadataOutput()
                    self.captureSession?.addOutput(captureMetadataOutput)
                    captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    captureMetadataOutput.metadataObjectTypes = self.supportedCodeTypes
                    
                    self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                    self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.videoPreviewLayer?.frame = self.view.bounds
                    self.scannerView.layer.addSublayer(self.videoPreviewLayer!)
                    
                    self.captureSession?.startRunning()
                    self.qrCodeFrameView = UIView()

                    if let qrCodeFrameView = self.qrCodeFrameView {
                        self.scannerView.addSubview(qrCodeFrameView)
                        self.scannerView.bringSubview(toFront: qrCodeFrameView)
                    }
                } catch {
                    print(error)
                    return
                }
            }
            else {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
                    if granted == true {
                        DispatchQueue.main.async {
                            let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
                            do {
                                let input = try AVCaptureDeviceInput(device: captureDevice!)
                                self.captureSession = AVCaptureSession()
                                self.captureSession?.addInput(input)
                                let captureMetadataOutput = AVCaptureMetadataOutput()
                                self.captureSession?.addOutput(captureMetadataOutput)
                                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                                captureMetadataOutput.metadataObjectTypes = self.supportedCodeTypes
                                
                                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                                self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                                self.videoPreviewLayer?.frame = self.view.bounds
                                self.scannerView.layer.addSublayer(self.videoPreviewLayer!)
                                
                                self.captureSession?.startRunning()
                                self.qrCodeFrameView = UIView()
                                
                                if let qrCodeFrameView = self.qrCodeFrameView {
                                    self.scannerView.addSubview(qrCodeFrameView)
                                    self.scannerView.bringSubview(toFront: qrCodeFrameView)
                                }
                            } catch {
                                print(error)
                                return
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.alert = UIAlertController(title: Constant.alertTitle(), message: AlertMessage.EnableCameraPermission, preferredStyle: UIAlertControllerStyle.alert)
                            self.alert.addAction(UIAlertAction(title: AlertTitle.Ok, style: UIAlertActionStyle.default, handler: nil))
                            self.present(self.alert, animated: true, completion: nil)
                            return
                        }
                    }
                })
            }
        } else {
            self.alert = UIAlertController(title: Constant.alertTitle(), message: AlertMessage.NoCameraAvailable, preferredStyle: UIAlertControllerStyle.alert)
            self.alert.addAction(UIAlertAction(title: AlertTitle.Ok, style: UIAlertActionStyle.default, handler: { (AlertAction) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(self.alert, animated: true, completion: nil)
            return
        }
    }
}

extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            self.alert = UIAlertController(title: Constant.alertTitle(), message: AlertMessage.NoQRCodeDetected, preferredStyle: UIAlertControllerStyle.alert)
            self.alert.addAction(UIAlertAction(title: AlertTitle.Ok, style: UIAlertActionStyle.default, handler: nil))
            self.present(self.alert, animated: true, completion: nil)
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                self.captureSession?.stopRunning()
                self.gistId = metadataObj.stringValue!
                self.presenter.getGistDetail(gistId: metadataObj.stringValue!)
                print(metadataObj.stringValue!)
            }
        }
    }
}

extension QRCodeScannerViewController: QRCodeScannerView {
    
    func finishGetGistDetailWithSuccess() {
        let gistCommentsViewController = self.storyboard?.instantiateViewController(withIdentifier: "GistCommentsViewController") as! GistCommentsViewController
        gistCommentsViewController.gistId = self.gistId
        self.navigationController?.pushViewController(gistCommentsViewController, animated: true)
    }
    
    func finishGetGistDetailWithError(error: String) {
        print(error)
        self.alert = UIAlertController(title: Constant.alertTitle(), message: error, preferredStyle: UIAlertControllerStyle.alert)
        self.alert.addAction(UIAlertAction(title: AlertTitle.Ok, style: UIAlertActionStyle.default, handler: { (completion) in
            self.getCamaraPermision()
        }))
        self.present(self.alert, animated: true, completion: nil)
        return
    }
}
