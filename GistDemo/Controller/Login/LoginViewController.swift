
import UIKit
import AlamofireOauth2

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.layer.borderColor = UIColor.black.cgColor
        self.loginButton.layer.borderWidth = 1.0
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        UsingOauth2(gistSettings, performWithToken: { token in
            GistDemoHttpRouter.OAuthToken = token
            let qrCodeScannerViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeScannerViewController") as! QRCodeScannerViewController
            self.navigationController?.pushViewController(qrCodeScannerViewController, animated: true)
        }, errorHandler: {
            Oauth2ClearTokensFromKeychain(gistSettings)
            let storage = HTTPCookieStorage.shared
            storage.cookies?.forEach() { storage.deleteCookie($0) }
        })
    }

}
