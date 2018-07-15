//
//  UserTableViewCell.swift
//  Master
//
//  Created by Diego on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

//class UserTableViewCell: UITableViewCell {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
//
//}

class UserImageCell: UITableViewCell {

    @IBOutlet weak var userPortraitImageView: UIImageView!
    @IBOutlet weak var userBackgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPortraitImageView.layer.borderWidth = 2
        userPortraitImageView.layer.borderColor = UIColor.white.cgColor
    }
    
}

class UserNameCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    
}

class UserInfoCell: UITableViewCell {
    
    // 更改名字
    @IBOutlet weak var userInfoTitle: UILabel!
    @IBOutlet weak var userInfoDetail: UILabel!
}

class UserProfileCell: UITableViewCell {
    
    @IBOutlet weak var userProfileLabel: UILabel!
}

class UserProfessionCell: UITableViewCell {
    
    @IBOutlet weak var userProfessionLabel: UILabel!
}

