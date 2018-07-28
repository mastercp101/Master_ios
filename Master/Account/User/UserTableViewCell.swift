//
//  UserTableViewCell.swift
//  Master
//
//  Created by Diego on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class UserImageCell: UITableViewCell {

    @IBOutlet weak var userPortraitImageView: UIImageView!
    @IBOutlet weak var userBackgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userPortraitImageView.layer.borderWidth = 3
        userPortraitImageView.layer.borderColor = UIColor.white.cgColor
    }
}

class UserNameCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    
}

class UserInfoCell: UITableViewCell {

    @IBOutlet weak var userInfoTitle: UILabel!
    @IBOutlet weak var userInfoDetail: UILabel!
}

class UserProfileCell: UITableViewCell {
    
    @IBOutlet weak var userProfileLabel: UILabel!
}

class UserProfessionCell: UITableViewCell {
    
    @IBOutlet weak var userProfessionLabel: UILabel!
}

class UserSginOutCell: UITableViewCell {
    
}


