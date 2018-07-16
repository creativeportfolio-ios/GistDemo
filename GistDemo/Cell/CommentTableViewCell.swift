
import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var commentDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let _ = self.userImageView {
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
            self.userImageView.layer.borderColor = UIColor.white.cgColor
            self.userImageView.layer.borderWidth = 1.0
            self.userImageView.clipsToBounds = true
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(comment: GistComment) {
        userNameLabel.text = comment.userName ?? ""
        commentLabel.text = comment.comment ?? ""
        commentDateLabel.text = comment.createdDate?.getCommentTime ?? ""
        
        
        
        if let imageUrl = comment.profileUrl {
            userImageView.sd_setShowActivityIndicatorView(true)
            userImageView.sd_setIndicatorStyle(.gray)
            userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "profile"))
        }
    }

}
