//
//  PostimageTableViewCell.swift
//  GOT
//
//  Created by Kenneth Okereke on 3/31/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class PostimageTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    var netService = NetworkingServices()
    
    var playButton: UIButton! = nil
    var player: AVPlayer!
    var playLayer: AVPlayerLayer!
    
    var posts: Post! = nil
    
    let actIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.startAnimating()
        return aiv
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.usernameLabel.text = ""
        self.postTextLabel.text = ""
        
        playLayer?.removeFromSuperlayer()
        player?.pause()
        playButton?.removeFromSuperview()
        actIndicatorView.stopAnimating()
    }
    
    func configureCell(post: Post) {
        posts = post
        
        
        self.postImageView.sd_setImage(with: URL(string: post.postImageURL), placeholderImage: UIImage(named: "Default-thumbnail"), options: SDWebImageOptions.cacheMemoryOnly) { (image, error, type, url) in
            self.addVideo()
            
        }
        
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
    
    func addVideo() {
        guard let post = posts else { return }
        if post.postVideoURL != "" {
            self.playButton = UIButton(type: .custom)
            
            let image = UIImage(named: "bt_play")
            let rect = self.postImageView.frame
            
            self.playButton.frame = CGRect(x: rect.origin.x + (rect.width-(image?.size.width)!)/2,
                                           y: rect.origin.y + (rect.height-(image?.size.height)!)/2,
                                           width: (image?.size.width)!,
                                           height: (image?.size.height)!)
            
            self.playButton.setImage(image, for: .normal)
            self.playButton.addTarget(self, action: #selector(actionPlay),
                                      for: .touchUpInside)
            
            self.addSubview(self.playButton)
            
            self.actIndicatorView.frame = self.playButton.frame
            self.addSubview(self.actIndicatorView)
            self.actIndicatorView.isHidden = true
        }
    }
    
    func actionPlay() {
        guard let post = posts else { return }
        if post.postVideoURL != "" {
            if let url = URL(string: post.postVideoURL) {
                player = AVPlayer(url: url)
                
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                
                playLayer = AVPlayerLayer(player: player)
                playLayer.frame = self.postImageView.frame
                
                self.layer.addSublayer(playLayer)
                player?.play()
                actIndicatorView.isHidden = false
                actIndicatorView.startAnimating()
                playButton.isHidden = true
            }
        }
    }
    
    func playerDidFinishPlaying() {
        playLayer?.removeFromSuperlayer()
        player?.pause()
        playButton.isHidden = false
        actIndicatorView.stopAnimating()
    }

    
    
}

