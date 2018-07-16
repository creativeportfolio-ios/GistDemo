
import Foundation
import AlamofireOauth2

let gistSettings = Oauth2Settings(
    baseURL: "https://api.github.com/authorizations",
    authorizeURL: "https://github.com/login/oauth/authorize",
    tokenURL: "https://github.com/login/oauth/access_token",
    redirectURL: "gistdemo://home",
    clientID: "995437183f8f74891677",
    clientSecret: "8ed633d8fb90f629945024f1d173e60c8969505b",
    scope: "gist"
)

class Constant {
    class func baseUrl() -> String {
        return "https://api.github.com/gists/"
    }
    
    class func alertTitle() -> String {
        return "GistDemo"
    }
    
    class func processing() -> String {
        return "Processing.."
    }
    
    class func commentPlaceholder() -> String {
        return "Type your comment here"
    }
}

struct AlertMessage {
    static let EnableCameraPermission = "Enable camera device access from youe iPhone settings"
    static let NoCameraAvailable = "Oops..Camera not available!"
    static let NoQRCodeDetected = "No QR code is detected"
    static let InValidQRCode = "Gist not found. Please try valid QR Code"
    static let SomethingWentWrong = "Something went wrong. Please try again later."
}

struct ErrorMessage {
    static let NotFound = "Not Found"
}

struct AlertTitle {
    static let Ok = "Ok"
}
