//
//  MessageBubbleView.swift
//  selfSizingChat
//
//  Created by 黎峻亦 on 2018/8/1.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class MessageBubbleView: UIView {
    var messageLabel : UILabel?
    var messageViewBG : UIView?
    let contentCellWidth : CGFloat
    var chatItem : ChatItem?
    
    let maxBubbleWidthRate : CGFloat = 0.7
    let contentMargin : CGFloat = 10.0
    let textfontSize : CGFloat = 16.0
    var offsetX : CGFloat = 0.0
    
    init(contentCellWidth : CGFloat){
        self.contentCellWidth = contentCellWidth
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBubbleViewFrame(chatItem : ChatItem){
        messageLabel?.removeFromSuperview()
        messageViewBG?.removeFromSuperview()
        self.chatItem = chatItem
        self.frame = setBasicFrame()
        setMessageLabel()
        setFinalBubbleViewFrame()
        setBubbleViewBackGround()
    }
    
    func setBasicFrame() -> CGRect{
        let maxBubbleViewWidth = contentCellWidth * maxBubbleWidthRate
        return CGRect(x: 0, y: 0, width: maxBubbleViewWidth, height: textfontSize)
    }
    
    func setMessageLabel(){
        let displayWidth = self.frame.width - 2 * contentMargin
        let displayFrame = CGRect(x: 0, y: 2 * contentMargin, width: displayWidth, height: textfontSize)
        let label = UILabel(frame: displayFrame)
        
        label.font = UIFont.systemFont(ofSize: textfontSize)
        label.numberOfLines = 0
        label.text = chatItem!.message
        label.textColor = UIColor.white
        label.sizeToFit()
        self.messageLabel = label
        self.addSubview(label)
    }
    
    func setFinalBubbleViewFrame(){
        let finalHeight : CGFloat = (self.messageLabel?.frame.height)! + 4 * contentMargin
        let messageLabelWidth = messageLabel!.frame.width
        
        if chatItem!.fromSelf{
            offsetX = contentCellWidth - messageLabelWidth - contentMargin * 4
        }else{
            offsetX = contentMargin * 4
        }
        self.frame = CGRect(x: offsetX, y: contentMargin, width: messageLabelWidth, height: finalHeight)
    }
    
    func setBubbleViewBackGround(){
        let bgView = UIView()
        bgView.frame.size = CGSize(width: messageLabel!.frame.width + 8, height: messageLabel!.frame.height + 5)
        bgView.center = messageLabel!.center
        bgView.layer.cornerRadius = 5
        if chatItem!.fromSelf{
            bgView.backgroundColor = UIColor(red:0.05, green:0.17, blue:0.33, alpha:1.0)
        }else{
            bgView.backgroundColor = UIColor(red:0.96, green:0.32, blue:0.11, alpha:1.0)
        }
        self.messageViewBG = bgView
        self.addSubview(bgView)
        self.sendSubview(toBack: bgView)
    }
    
}
