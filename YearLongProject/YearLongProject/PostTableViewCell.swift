//
//  MyTableViewCell.swift
//  YearLongProject
//
//  Created by Derek Stengel on 3/25/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    
    public func configure(with post: Post) {
        profilePicture.image = UIImage(systemName: "person.circle.fill")?.withTintColor(.purple)
        user.text = post.user
        date.text = post.date
        handle.text = post.handle
        bodyText.text = post.body
        user.text = post.user
        numberOfComments.text = post.numberOfComments
        numberOfLikes.text = post.numberOfLikes
//        likesButton.backgroundColor = .clear
    }
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var user: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var handle: UILabel!
    @IBOutlet var bodyText: UILabel!
    @IBOutlet var numberOfComments: UILabel!
    @IBOutlet var numberOfLikes: UILabel!
    @IBOutlet var likesButton: UIButton!
    
    var likesCount: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.contentMode = .scaleAspectFit
        likesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likesButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        
        likesButton.setBackgroundImage(UIImage(), for: .normal)
        likesButton.setBackgroundImage(UIImage(), for: .selected)
        
//        numberOfLikes.text = "\(likesCount)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likesButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            likesCount += 1
        } else {
            likesCount -= 1
        }
        
        numberOfLikes.text = "\(likesCount)"
        
//        sender.backgroundColor = .clear
    }
    
    
}
