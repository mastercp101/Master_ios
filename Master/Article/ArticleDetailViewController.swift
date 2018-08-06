//
//  ArticleDetailViewController.swift
//  Master
//
//  Created by Diego on 2018/8/2.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

private let experienceArticleServlet = "ExperienceArticleServlet"

private let articleDetailCell = "ArticleDetailCell"
private let articleToMessageCell = "ArticleToMessageCell"
private let noneMessageCell = "NoneMessageCell"
private let loadingCell = "LoadingCell"

class ArticleDetailViewController: UIViewController {
    
    // 傳過來的資料
    var selectArticleIndex: Int?
    // 是否有更新資料?
    private var isNew = false
    // 留言資訊
    private var comments = [ArticleComment]()
    // tableView
    private var tableView: UITableView?

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var viewBottomLayout: NSLayoutConstraint!
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.delegate = self
        // 找到 TableView
        for view in self.view.subviews {
            if view is UITableView, let tableView = view as? UITableView {
                self.tableView = tableView
                break
            }
        }
        // 關閉 Table Delay
        tableView?.delaysContentTouches = false
        // 監聽鍵盤
        NotificationCenter.default.addObserver(self, selector: #selector(moveBottomViewUp(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let index = selectArticleIndex else { return }
        // 留言數不等於 0 連線取資料 ...
        if ArticleData.shared.info[index].commentCount != 0 {
            getArticleComment(postId: ArticleData.shared.info[index].postId)
        }
    }
    
    @objc func moveBottomViewUp(_ aNotification: Notification) {
        let info = aNotification.userInfo
        let sizeValue = info![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let size = sizeValue.cgRectValue.size
        let height = size.height
        self.viewBottomLayout.constant = height
        UIView.animate(withDuration: 0.23){
            self.view.layoutIfNeeded()
        }
    }
    
    private func endEdit() {
        commentTextField.resignFirstResponder()
        viewBottomLayout.constant = 0
        UIView.animate(withDuration: 0.23, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func goBackToArticleHome(_ sender: UIBarButtonItem) {
        endEdit()
        self.dismiss(animated: true) {
            
            if self.isNew {
                NotificationCenter.default.post(name: .updateArticle, object: nil, userInfo: ["updateArticle" : self.selectArticleIndex ?? -1])
            }
        }
    }
    
    
    @IBAction func detailClinkLike(_ sender: UIButton) {
        
        guard let account = userAccount, let index = selectArticleIndex else { return }
        // 拿到修改前數值
        let isLike = ArticleData.shared.info[index].postLike
        // 開始連接修改
        changeExperiencePostLike(account: account, postId: ArticleData.shared.info[index].postId, isLike: !isLike, index: index)
        // 回存相反結果
        ArticleData.shared.info[index].postLike = !isLike
        // 拿到 cell 本體
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = tableView?.cellForRow(at: indexPath) as? ArticleDetailTableViewCell else { return }
        // 讚數量
        var likeNumber = ArticleData.shared.info[index].postLikes
        
        if isLike {
            cell.articleDetailLikeButton.tintColor = UIColor.black
            likeNumber -= 1
        } else {
            cell.articleDetailLikeButton.tintColor = UIColor.blue
            likeNumber += 1
        }
        cell.articleDetailLikes.text = "\(likeNumber)"
        ArticleData.shared.info[index].postLikes = likeNumber
        isNew = true
    }
    
    @IBAction func detailClinkTalk(_ sender: UIButton) {
        commentTextField.becomeFirstResponder()
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
        
        guard let text = commentTextField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else {
            commentTextField.text?.removeAll()
            return
        }
        endEdit()
        Alert.shared.buildDoubleAlert(viewController: self, alertTitle: "確定發布?", alertMessage: nil, actionTitles: ["取消","確定"], firstHandler: { (action) in
            // 取消
        }) { (action) in
            // 確定
            guard let index = self.selectArticleIndex, let account = userAccount else { return }
            self.setArticleComment(account: account, postId: ArticleData.shared.info[index].postId, content: text, returnIndex: index)
            self.commentTextField.text?.removeAll()
        }
    }

    @IBAction func detailClinkbBlank(_ sender: UITapGestureRecognizer) {
        endEdit()
    }
    
    

 // MARK: - Connect DataBase Methods
    
    // 拿到留言資訊
    private func getArticleComment(postId: Int) {
        
        let request: [String: Any] = ["experienceArticle": "getExperienceComment",
                                      "postId": postId]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            let decoder = JSONDecoder()
            
            let results = try? decoder.decode([ArticleComment].self, from: data)
            
            guard let result = results else { return }
            
            if result.count != 0 {
                self.comments = result
                self.tableView?.reloadData()
            }
        }
    }
    // 拿到大頭照
    private func getCommentPortrait(target: UIImageView, account: String, index: Int) {
        
        let url = urlString + "CourseArticleServlet"
        let request = ["courseArticle" : "getPhotoByUserId", "userId" : account]

        Task.postRequestData(urlString: url, request: request) { (error, data) in
            
            guard error == nil, let data = data else {
                if let image = UIImage(named: "user_default_por") {
                    self.comments[index].user_Portrait = UIImageJPEGRepresentation(image, 1.0)
                    DispatchQueue.main.async { target.image = image }
                }
                return
            }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results, let resultString = result as? String else {
                if let image = UIImage(named: "user_default_por") {
                    self.comments[index].user_Portrait = UIImageJPEGRepresentation(image, 1.0)
                    DispatchQueue.main.async { target.image = image }
                }
                return
            }
            guard let dataImage = Data(base64Encoded: resultString) else {
                if let image = UIImage(named: "user_default_por") {
                    self.comments[index].user_Portrait = UIImageJPEGRepresentation(image, 1.0)
                    DispatchQueue.main.async { target.image = image }
                }
                return
            }
            self.comments[index].user_Portrait = dataImage
            DispatchQueue.main.async { target.image = UIImage(data: dataImage) }
        }
    }
    // 依據自己, 修改點讚狀態
    private func changeExperiencePostLike(account: String, postId: Int, isLike: Bool, index: Int) {
        
        let request: [String: Any] = ["experienceArticle": "getExperiencePostLikeRefresh",
                                      "userId": account,
                                      "postId": postId,
                                      "checked": isLike]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results, let resultInt = result as? Int else { return }
            
            ArticleData.shared.info[index].postLikes = resultInt
        }
    }
    // 留言
    private func setArticleComment(account: String, postId: Int, content: String, returnIndex: Int) {
        
        let request: [String: Any] = ["experienceArticle": "setExperienceComment",
                                      "userName": account,
                                      "postId": postId,
                                      "commentStr": content]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let commentResult = result as? Int else { return }
            
            if commentResult > 0 {
                // TODO: - Server 端不管結果怎樣都會傳回 1 以上的數字 (笑) 除非 Server 當機
            }
            
            // 新資料!!!
            self.isNew = true
            // 現在時間
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let time = formatter.string(from: Date())
            // 加入陣列
            self.comments.append(ArticleComment(comment_id: nil, post_id: nil, user_id: nil, comment_content: content, comment_time: time, user_name: userName, user_Portrait: userPortrait))
            // 判斷是不是第一筆留言
            let indexPath = IndexPath(row: self.comments.count, section: 0)
            if self.comments.count == 1 {
                self.tableView?.reloadData() // 第一筆
            } else {
                self.tableView?.insertRows(at: [indexPath], with: .fade) // 非第一筆
            }
            // 畫面拉到最下面
            self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
            // 修改資料留言數
            if let commentCount = ArticleData.shared.info[returnIndex].commentCount {
                ArticleData.shared.info[returnIndex].commentCount = commentCount + 1
            }
            // 如果現在畫面是可見的話去修改畫面數字 ...
            if let cell = self.tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? ArticleDetailTableViewCell {
                cell.articleDetailTalks.text = "\(ArticleData.shared.info[returnIndex].commentCount ?? 0) 則留言"
            }
           // cellForRow 比須在cell可見下才能工作
            var delays = 0.0
            switch self.comments.count {
            case 1-30:
                delays = 0.1
            case 31-60:
                delays = 0.2
            case 61-90:
                delays = 0.3
            default:
                delays = 0.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delays) {
                if let commentCell = self.tableView?.cellForRow(at: indexPath) {
                    commentCell.alpha = 0.5
                    UIView.animate(withDuration: 1) {
                        commentCell.alpha = 1
                    }
                }
            }
        }
        
    }
    
}



extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.count == 0 {
            return 2
        }
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: articleDetailCell, for: indexPath) as? ArticleDetailTableViewCell, let index = selectArticleIndex else {
                return UITableViewCell()
            }
            // 發文者圖片
            if let photoData = ArticleData.shared.info[index].postPhoto {
                cell.articleDetailPhoto.image = UIImage(data: photoData)
            } else {
                cell.articleDetailPhoto.image = UIImage(named: "user_default_por")
            }
            // 發文者大頭照
            if let data = ArticleData.shared.info[index].postPortrait {
                cell.articleDetailPortrait.image = UIImage(data: data)
            } else {
                cell.articleDetailPortrait.image = UIImage(named: "user_default_por")
            }
            // 名字時間內容
            cell.articleDetailName.text = ArticleData.shared.info[index].userName
            cell.articleDetailDate.text = ArticleData.shared.info[index].postTime
            cell.articleDetailContent.text = ArticleData.shared.info[index].postContent
            // 讚數及留言數
            cell.articleDetailLikes.text = "\(ArticleData.shared.info[index].postLikes)"
            cell.articleDetailTalks.text = "\(ArticleData.shared.info[index].commentCount ?? 0) 則留言"
            // 讚按鈕狀態
            if ArticleData.shared.info[index].postLike {
                cell.articleDetailLikeButton.tintColor = UIColor.blue
            } else {
                cell.articleDetailLikeButton.tintColor = UIColor.black
            }

            return cell
            
        default:
            
            if comments.count == 0 {
                
                guard let index = selectArticleIndex else { return UITableViewCell() }
                switch ArticleData.shared.info[index].commentCount {
                case 0:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: noneMessageCell, for: indexPath) as? NoneMessageTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clinkbBlankEndEdit)))
                    return cell
                default:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: loadingCell, for: indexPath) as? LoadingTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.loadingView.startAnimating()
                    return cell
                }
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: articleToMessageCell, for: indexPath) as? ArticleToMessageTableViewCell else {
                return UITableViewCell()
            }
            let index = indexPath.row - 1
            // 留言人大頭照
            if let image = comments[index].user_Portrait {
                cell.messageImageView.image = UIImage(data: image)
            } else if let userId = comments[index].user_id {
                getCommentPortrait(target: cell.messageImageView, account: userId, index: index)
            } else {
                cell.messageImageView.image = UIImage(named: "user_default_por")
            }
            // 名字時間留言內文
            cell.messageNameLabel.text = comments[index].user_name
            cell.messageDateLabel.text = comments[index].comment_time
            cell.messageDetailLabel.text = comments[index].comment_content
            // 加入點擊事件
            cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clinkbBlankEndEdit)))
            
            return cell
        }
    }
    // 點擊空白處, 結束編輯
    @objc private func clinkbBlankEndEdit() {
        endEdit()
    }
}

extension ArticleDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEdit()
        return true
    }
}
