

import UIKit
import SDWebImage

class GistCommentsViewController: UIViewController {

    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var noCommentLabel: UILabel!
    
    var presenter: GistCommentPresenter = GistCommentPresenter(provider: GistCommentProvider())
    lazy var gistId: String = ""
    var commentArray = [GistComment]()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attachView(view: self)
        self.getComments()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: UIControlEvents.valueChanged)
        
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
        let postCommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostCommentViewController") as! PostCommentViewController
        postCommentViewController.gistId = self.gistId
        postCommentViewController.delegate = self
        self.navigationController?.pushViewController(postCommentViewController, animated: true)
    }
}
//MARK: UITableView DataSource
extension GistCommentsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(comment: self.commentArray[indexPath.row])
        return cell
    }
}

//MARK: Custom Delegate
extension GistCommentsViewController: PostCommentDelegate {
    func postComment(userName: String, comment: String, imageUrl: String) {
        let gistComment = GistComment()
        gistComment?.comment = comment
        gistComment?.createdDate = Date().getCurrentDateString()
        gistComment?.profileUrl = imageUrl
        gistComment?.userName = userName
        self.commentArray.append(gistComment!)
        self.commentTableView.reloadData()
    }
}

extension GistCommentsViewController {
   
    @objc func pullToRefresh() {
        self.presenter.getGistComments(gistId: gistId, showProgress:false)
    }
    
    func getComments(showProgress:Bool = true) {
        self.presenter.getGistComments(gistId: gistId, showProgress:showProgress)
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
        if let commentList = gistComment?.data {
            self.commentArray = commentList
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
