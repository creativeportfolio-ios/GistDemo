
import Foundation

class GistCommentPresenter {
    
    let provider: GistCommentProvider
    weak private var gistCommentView: GistCommentView?
    
    // MARK: - Initialization & Configuration
    init(provider: GistCommentProvider) {
        self.provider = provider
    }
    
    func attachView(view: GistCommentView?) {
        guard let view = view else { return }
        gistCommentView = view
    }
    
    func getGistComments(gistId: String) {
        provider.getGistComments(gistId: gistId, successHandler: { (response)  in
            self.gistCommentView?.finishGetGistCommentsWithSuccess(gistComment: response)
        }, errorHandler: {(error) in
            self.gistCommentView?.finishGetGistCommentsWithError(error: error)
        })
    }
}
