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
    private init() {}
    
    var info = [ExperienceArticle]()
}

struct ExperienceArticle: Codable {
    
    let postId: Int? // 文章ID
    let userId: String? // 發文者ID
    let postContent: String? // 內文
    let postTime: String? // 時間
    let photoId: Int? // 文章圖片ID
    let userName: String? // 發文者名稱
    
    var postLike: Bool? // 你是否有點過讚?
    var postLikes: Int? // 讚 總數量
    
    var postPortrait: Data?
    var postPhoto: Data?
    var commentCount: String?
}




