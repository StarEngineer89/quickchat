//
//  TextTableViewCell.swift
//  GOT
//
//  Created by Kenneth Okereke on 3/31/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var verifiedImageView: UIImageView!
    
    var netService = NetworkingServices()

    override func prepareForReuse() {
        super.prepareForReuse()
        self.usernameLabel.text = ""
        self.postTextLabel.text = ""
    }
    
    func configureCell(post: Post){
        
        netService.fetchPostUserInfo(forUserID: post.userId) { (user) in
            if let user = user {
                self.userImageView.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "Default"))
                self.usernameLabel.text = user.getemail()
                self.verifiedImageView.isHidden = !user.isVerified
            }
        }
        
        
        
        self.postTextLabel.text = post.postText
        
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval(post.postDate))
        let toDate = NSDate()
        
        let differenceOfDate = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfMonth], from: fromDate as Date, to: toDate as Date)
        if differenceOfDate.second! <= 0 {
            dateLabel.text = "now"
        } else if differenceOfDate.second! > 0 && differenceOfDate.minute! == 0 {
            dateLabel.text = "\(differenceOfDate.second!)secs."
            
        }else if differenceOfDate.minute! > 0 && differenceOfDate.hour! == 0 {
            dateLabel.text = "\(differenceOfDate.minute!)mins."
            
        }else if differenceOfDate.hour! > 0 && differenceOfDate.day! == 0 {
            dateLabel.text = "\(differenceOfDate.hour!)hrs."
            
        }else if differenceOfDate.day! > 0 && differenceOfDate.weekOfMonth! == 0 {
            dateLabel.text = "\(differenceOfDate.day!)dys."
            
        }else if differenceOfDate.weekOfMonth! > 0 {
            dateLabel.text = "\(differenceOfDate.weekOfMonth!)wks."
            
        }
        
        
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
