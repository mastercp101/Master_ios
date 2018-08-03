//
//  ChatRoom.swift
//  Master
//
//  Created by 黎峻亦 on 2018/8/2.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
struct ChatRoom : Codable{
    let friendUserID : String
    let roomName : String
    let roomPosition : String
    let lastMessage : String
    
    enum CodingKeys : String,CodingKey{
        case friendUserID = "friend_user_id"
        case roomName = "room_name"
        case roomPosition = "room_position"
        case lastMessage = "last_message"
    }
}

struct ChatItem{
    let userID : String
    let message : String
    let fromSelf : Bool
    
    init(userID : String,message : String) {
        self.userID = userID
        self.message = message
        self.fromSelf = userID == userAccount
    }
}

class ChatItemSingleTon{
    static let shared = ChatItemSingleTon()
    init(){}
    var friendPortrait : UIImage?
    var cellContentViewWidth : CGFloat = 0.0
}
