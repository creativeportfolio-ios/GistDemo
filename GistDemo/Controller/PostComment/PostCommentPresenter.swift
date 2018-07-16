
import Foundation

class PostCommentPresenter {
    
    let provider: PostCommentProvider
    weak private var postCommentView: PostCommentView?
    
    // MARK: - Initialization & Configuration
    init(provider: PostCommentProvider) {
        self.provider = provider
    }
    
    func attachView(view: PostCommentView?) {
        guard let view = view else { return }
        postCommentView = view
    }
    
    func postComment(gistId: String, comment: String) {
        provider.postComment(gistId: gistId, comment: comment, successHandler: { (response)  in
            self.postCommentView?.finishPostCommentWithSuccess(gistComment: response)
        }, errorHandler: {(error) in
            self.postCommentView?.finishPostCommentWithError(error: error)
        })
    }
}
