//
//  messageRoomItemCell.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/17.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class messageRoomItemCell : UITableViewCell{
    @IBOutlet weak var userPropertyImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
}

class messageFromOtherCell : UITableViewCell{
    @IBOutlet weak var userPropertyImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
}

