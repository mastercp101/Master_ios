//
//  ArticleTableViewCell.swift
//  Master
//
//  Created by Diego on 2018/7/26.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var postsPortraitImage: UIImageView!
    @IBOutlet weak var postsNameLabel: UILabel!
    @IBOutlet weak var postsDateLabel: UILabel!
    
    @IBOutlet weak var postsContentLabel: UILabel!
    @IBOutlet weak var postsContentImage: UIImageView!
    
    @IBOutlet weak var postsLikeNumberLabel: UILabel!
    @IBOutlet weak var postsTalkNumberLabel: UILabel!

    @IBOutlet weak var postsLikeButton: UIButton!
    @IBOutlet weak var postsTalkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var frame: CGRect {
        
        didSet {
            var newFrame = frame
//            newFrame.origin.x += 10
            newFrame.origin.y += 5
//            newFrame.size.width -= 20
            newFrame.size.height -= 10
            super.frame = newFrame
        }
    }
}

// 文章內文
class ArticleDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleDetailPortrait: UIImageView!
    @IBOutlet weak var articleDetailName: UILabel!
    @IBOutlet weak var articleDetailDate: UILabel!
    @IBOutlet weak var articleDetailContent: UILabel!
    @IBOutlet weak var articleDetailPhoto: UIImageView!
    @IBOutlet weak var articleDetailLikes: UILabel!
    @IBOutlet weak var articleDetailTalks: UILabel!
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
//            newFrame.origin.x += 10
//            newFrame.size.width -= 20
            newFrame.origin.y += 5
            newFrame.size.height -= 15
            super.frame = newFrame
        }
    }
}

// 留言
class ArticleToMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageNameLabel: UILabel!
    @IBOutlet weak var messageDetailLabel: UILabel!
    @IBOutlet weak var messageDateLabel: UILabel!
    
//    override var frame: CGRect {
//        didSet {
//            var newFrame = frame
//            newFrame.origin.x += 10
//            newFrame.size.width -= 20
//            super.frame = newFrame
//        }
//    }
}

// 沒有留言
class NoneMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noneMessageLabel: UILabel!
    
//    override var frame: CGRect {
//        didSet {
//            var newFrame = frame
//            newFrame.origin.x += 10
//            newFrame.size.width -= 20
//            super.frame = newFrame
//        }
//    }
}

// 讀取
class LoadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
//    override var frame: CGRect {
//        didSet {
//            var newFrame = frame
//            newFrame.origin.x += 10
//            newFrame.size.width -= 20
//            super.frame = newFrame
//        }
//    }
}

