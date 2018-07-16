
import Foundation

protocol GistCommentView: class {
    func finishGetGistCommentsWithSuccess(gistComment: GistCommentModel?)
    func finishGetGistCommentsWithError(error: String)
}
