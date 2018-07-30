//
//  ArticleViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class ArticleData {
    
    static let shared = ArticleData()
    private init(){}
    
    var info = [ExperienceArticle]()
}

struct ExperienceArticle: Codable {
    
    let postId: Int // 文章ID
    let userId: String // 發文者ID
    let postContent: String // 內文
    let postTime: String // 時間
    let photoId: Int // 文章圖片ID
    let userName: String // 發文者名稱
    var postLike: Bool // 你是否有點過讚?
    var postLikes: Int // 讚 總數量
    
    var postPortrait: Data?
    var postPhoto: Data?
    var commentCount: String?
}

extension UIImage {
    
    func resize(maxWidthHeight: CGFloat) -> UIImage? {
        
        //檢查是否圖片已經小於imageView
        if self.size.width <= maxWidthHeight &&
            self.size.height <= maxWidthHeight {
            return self
        }
        
        //決定大小
        let finalSize: CGSize
        if self.size.width >= self.size.height{
            let ratio = self.size.width / maxWidthHeight
            finalSize = CGSize(width: maxWidthHeight, height: self.size.height / ratio)
        } else {
            let ratio = self.size.height / maxWidthHeight
            finalSize = CGSize(width: self.size.width / ratio, height: maxWidthHeight)
            
        }
        
        UIGraphicsBeginImageContext(finalSize) //虛擬畫布//C語言的API->要小心記憶體管理(ARC無效)
        let drawRect = CGRect(x: 0, y: 0, width: finalSize.width, height: finalSize.height)
        self.draw(in: drawRect) //image把自己畫在一個小畫布上
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() //極重要！！
        return result
        
    }
    
}


