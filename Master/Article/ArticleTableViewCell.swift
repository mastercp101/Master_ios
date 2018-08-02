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
