

import UIKit
import SDWebImage

class GistCommentsViewController: UIViewController {

    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var noCommentLabel: UILabel!
    
    var presenter: GistCommentPresenter = GistCommentPresenter(provider: GistCommentProvider())
    var gistId: String?
    var commentArray = [GistComment]()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attachView(view: self)
        self.getComments()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(self.getComments), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            self.commentTableView.refreshControl = refreshControl
        } else {
            self.commentTableView.addSubview(refreshControl)
        }

        self.commentTableView.tableFooterView = UIView()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postCommentClicked(_ sender: UIButton) {
        //redirect to postComment
    }
}

extension GistCommentsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentTableViewCell
        let commment = self.commentArray[indexPath.row]
        
        cell.userNameLabel.text = commment.userName ?? ""
        cell.commentLabel.text = commment.comment ?? ""
        cell.commentDateLabel.text = commment.createdDate?.getCommentTime ?? ""
        
        cell.userImageView.sd_setShowActivityIndicatorView(true)
        cell.userImageView.sd_setIndicatorStyle(.gray)
        
        if let imageUrl = commment.profileUrl {
            cell.userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "profile"))
        }
        else {
            cell.userImageView.image = UIImage(named: "profile")
        }
        return cell
    }
}


extension GistCommentsViewController {
    @objc func getComments() {
        self.presenter.getGistComments(gistId: gistId ?? "")
    }
    
    func openAlertView(message: String) {
        let alertController = UIAlertController(title: Constant.alertTitle(), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertTitle.Ok, style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension GistCommentsViewController: GistCommentView {
    func finishGetGistCommentsWithSuccess(gistComment: GistCommentModel?) {
        self.refreshControl.endRefreshing()
        if let _ = gistComment {
            self.commentArray = (gistComment?.data!)!
            self.noCommentLabel.isHidden = true
            self.commentTableView.isHidden = false
            self.commentTableView.reloadData()
        }
        else {
            self.noCommentLabel.isHidden = false
            self.commentTableView.isHidden = true
        }
    }
    
    func finishGetGistCommentsWithError(error: String) {
        self.refreshControl.endRefreshing()
        self.openAlertView(message: error)
    }
}
