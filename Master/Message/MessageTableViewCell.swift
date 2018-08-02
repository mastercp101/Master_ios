//
//  MessageTableViewCell.swift
//  selfSizingChat
//
//  Created by 黎峻亦 on 2018/8/1.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {
    var userProfile : UIImageView?
    var nameTextLabel : UILabel?
    let cellContentViewWidth = ChatItemSingleTon.shared.cellContentViewWidth
    let textfontSize : CGFloat = 14.0
    let contentMargin : CGFloat = 10.0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(messageBubbleView)
        setBubbleViewConstraint(bubleViw: messageBubbleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBubbleViewConstraint(bubleViw : MessageBubbleView){
        let height = bubleViw.frame.height
        let width = bubleViw.frame.width
        bubleViw.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        bubleViw.heightAnchor.constraint(equalToConstant: height).isActive = true
        bubleViw.widthAnchor.constraint(equalToConstant: width).isActive = true
        bubleViw.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    lazy var messageBubbleView : MessageBubbleView = {
        var messageBubbleView = MessageBubbleView(contentCellWidth: cellContentViewWidth)
        return messageBubbleView
    }()
    
    func setImage(chatItem : ChatItem){
        userProfile?.removeFromSuperview()
        var frame : CGRect
        if chatItem.fromSelf{
            frame = CGRect(x: cellContentViewWidth - 35, y: 3, width: 30, height: 30)
        }else{
            frame = CGRect(x: 10, y: 3, width: 25, height: 25)
        }
        let imageView = UIImageView(frame: frame)
        imageView.getUserPortrait(account: chatItem.userID, index: nil)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.userProfile = imageView
        self.contentView.addSubview(imageView)
    }
    
    func setNameLabel(chatItem : ChatItem){
        nameTextLabel?.removeFromSuperview()
        var frame = CGRect(x: 0, y: 0, width: 200, height: textfontSize)
        let label = UILabel(frame: frame)
        label.font = UIFont.systemFont(ofSize: textfontSize)
        label.text = chatItem.userID
        label.numberOfLines = 0
        label.sizeToFit()
        
        let width = label.frame.width
        if chatItem.fromSelf{
            frame = CGRect(x: messageBubbleView.frame.maxX - width, y: contentMargin, width: width
                , height: textfontSize)
        }else{
            frame = CGRect(x: messageBubbleView.frame.minX, y: contentMargin, width: width, height: textfontSize)
        }
        label.frame = frame
        self.nameTextLabel = label
        self.contentView.addSubview(label)
    }
    
}
