//
//  PhotoItemViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/30.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

private let experienceArticleServlet = "ExperienceArticleServlet"


enum PhotoItemEntrance {
    case article   // 從文章
    case photo // 從相簿
    case none
}


class PhotoItemViewController: UIViewController {

    // 傳過來的資料
    var selectIndex: Int?
    var userEntrance: PhotoItemEntrance = .none
    
    var article : ExperienceArticle?
    
    @IBOutlet weak var phototScrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var ArticleContentLabel: UILabel!
    @IBOutlet weak var ArticleMoreButton: UIButton!
    @IBOutlet weak var ArticleLikeButton: UIButton!
    @IBOutlet weak var AritcleCommentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 準備資料
        prepareObject()
        // 準備圖片
        setImageView()
        // 準備畫面內容
        prepareView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    // 點讚
    @IBAction func likeBtnTapped(_ sender: Any) {

        if let account = userAccount, let like = article?.postLike, let postId = article?.postId {
            // 修改按鈕顏色
            if !like {
                ArticleLikeButton.tintColor = UIColor(red: 70/255, green: 150/255, blue: 1, alpha: 1)
            } else {
                ArticleLikeButton.tintColor = UIColor.white
            }
            // 回存相反布林值
            article?.postLike = !like
            changeExperiencePostLike(account: account, postId: postId, isLike: !like)
        }
    }
    
    // 刷新留言數
    @IBAction func PhotoItemGoBack(segue: UIStoryboardSegue) {
        
        if let commentCount = article?.commentCount {
            AritcleCommentButton.setTitle(" \(commentCount) 則留言", for: .normal)
        }
    }
    
    // 準備資料
    private func prepareObject() {

        guard let index = selectIndex else { return }
        
        switch userEntrance {
        case .article:
            article = ArticleData.shared.info[index]
        case .photo:
            article = UserPhotoData.shared.info[index]
        default:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // 準備圖片
    private func setImageView(){
        phototScrollView.minimumZoomScale = 1.0
        phototScrollView.maximumZoomScale = 3.0
        
        switch userEntrance {
        case .article:
            guard let index = selectIndex else { fallthrough }
            if let articlePhotoData = ArticleData.shared.info[index].postPhoto {
                photoImageView.image = UIImage(data: articlePhotoData)
            } else {
                photoImageView.image = UIImage(named: "user_default_bkgd")
            }
        case .photo:
            guard let index = selectIndex else { fallthrough }
            if let articlePhotoData = UserPhotoData.shared.info[index].postPhoto {
                photoImageView.image = UIImage(data: articlePhotoData)
            } else {
                photoImageView.image = UIImage(named: "user_default_bkgd")
            }
        default:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func prepareView() {
        // 準備 Navigation - 透明
        setNav()
        // 寫入文本
        ArticleContentLabel.text = article?.postContent ?? ""
        // 判斷是否需要 "更多" 按鈕 ?
        ArticleMoreButton.isHidden = true
        let textWidth = ArticleContentLabel.text!.size(withAttributes: [.font : UIFont.systemFont(ofSize: 16.0)]).width
        if textWidth > ArticleContentLabel.frame.size.width { ArticleMoreButton.isHidden = false }
        // 判斷點讚狀態
        if article?.postLike ?? false {
            ArticleLikeButton.tintColor = UIColor(red: 70/255, green: 150/255, blue: 1, alpha: 1)
        } else {
            ArticleLikeButton.tintColor = UIColor.white
        }
        // 拿到留言數量
        if let commentCount = article?.commentCount {
            AritcleCommentButton.setTitle(" \(commentCount) 則留言", for: .normal)
        } else {
            getExperienceCommentCount(postId: article?.postId, target: AritcleCommentButton)
        }
    }
    
    private func setNav(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? CommentDialogViewController {
            controller.dialogArticle = article
        }
    }
    
    // 將資料回去倒
    @IBAction func backBtnTapped(_ sender: Any) {
        
        guard let index = selectIndex, let returnData = article else { return }
        
        self.dismiss(animated: true) {
            
            switch self.userEntrance {
            case .article:
                ArticleData.shared.info[index] = returnData
                NotificationCenter.default.post(name: .updateArticle, object: nil, userInfo: ["updateArticle" : index])
            case .photo:
                UserPhotoData.shared.info[index] = returnData
            case .none:
            
                print("nope")
                
            } 
        }
    }
}


extension PhotoItemViewController : UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
}


extension PhotoItemViewController { // MARK: - Connect DataBase Methods
    
    // 依據自己, 修改點讚狀態
    private func changeExperiencePostLike(account: String, postId: Int, isLike: Bool) {
        
        let request: [String: Any] = ["experienceArticle": "getExperiencePostLikeRefresh",
                                      "userId": account,
                                      "postId": postId,
                                      "checked": isLike]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results, let resultInt = result as? Int else { return }
            
            if resultInt < 1 { print("*** 相片頁面修改點讚狀態失敗 ***") }
        }
    }
    
    // 拿到留言總數
    private func getExperienceCommentCount(postId: Int?, target: UIButton) {

        guard let postId = postId else {
            self.article?.commentCount = 0
            target.setTitle(" 0 則留言", for: .normal)
            return
        }
        
        let request: [String: Any] = ["experienceArticle": "getExperienceCommentCount",
                                      "postId": postId]

        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in

            guard error == nil, let data = data else {
                self.article?.commentCount = 0
                target.setTitle(" 0 則留言", for: .normal)
                return
            }
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)

            guard let result = results, let resultInt = result as? Int else {
                self.article?.commentCount = 0
                target.setTitle(" 0 則留言", for: .normal)
                return
            }
            target.setTitle(" \(resultInt) 則留言", for: .normal)
            self.article?.commentCount = resultInt
        }
    }
    
}



