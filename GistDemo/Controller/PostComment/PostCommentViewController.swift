
import UIKit

@objc protocol PostCommentDelegate {
    @objc func postComment(userName: String, comment: String, imageUrl: String)
}

class PostCommentViewController: UIViewController {

    @IBOutlet weak var commentTextView: UITextView!
    
    var presenter: PostCommentPresenter = PostCommentPresenter(provider: PostCommentProvider())
    lazy var gistId: String = ""
    let commentPlaceHodler = Constant.commentPlaceholder()
    var delegate: PostCommentDelegate?
    var gistCommentModel: GistComment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.text = commentPlaceHodler
        commentTextView.textColor = UIColor.darkGray
        commentTextView.delegate = self

        self.presenter.attachView(view: self)
    }

    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postClicked(_ sender: UIButton) {
        if isCommentValid() {
            self.presenter.postComment(gistId: self.gistId, comment: self.commentTextView.text)
        }
        else {
            self.openAlertView(message: AlertMessage.AddCommentAlert, isHandler: false)
        }
    }
}

extension PostCommentViewController {
    func isCommentValid() -> Bool {
        if let comment = self.commentTextView.text, comment.count > 0, comment != commentPlaceHodler {
            return true
        }
        return false
    }
    
    func openAlertView(message: String, isHandler: Bool) {
        let alertController = UIAlertController(title: Constant.alertTitle(), message: message, preferredStyle: .alert)        
        alertController.addAction(UIAlertAction(title: AlertTitle.Ok, style: .default, handler: { (alertAction) in
            if isHandler {
                _ = self.delegate?.postComment(userName: self.gistCommentModel?.userName ?? "", comment: self.gistCommentModel?.comment ?? "", imageUrl: self.gistCommentModel?.profileUrl ?? "")
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension PostCommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.layoutIfNeeded()
        if (commentTextView.text == commentPlaceHodler) {
            commentTextView.text = nil
            commentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView!.text.isEmpty {
            commentTextView.text = commentPlaceHodler
            commentTextView.textColor = UIColor.darkGray
        }
        textView.resignFirstResponder()
    }
}

extension PostCommentViewController: PostCommentView {
    func finishPostCommentWithSuccess(gistComment: GistComment?) {
        self.gistCommentModel = gistComment
        self.openAlertView(message: AlertMessage.CommentSuccessMessage, isHandler: true)
    }
    
    func finishPostCommentWithError(error: String) {
        self.openAlertView(message: error, isHandler: false)
    }
}
