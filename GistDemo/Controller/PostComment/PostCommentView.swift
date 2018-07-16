
import Foundation

protocol PostCommentView: class {
    func finishPostCommentWithSuccess(gistComment: GistComment?)
    func finishPostCommentWithError(error: String)
}
