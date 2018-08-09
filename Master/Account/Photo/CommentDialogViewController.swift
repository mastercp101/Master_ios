//
//  CommentDialogViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/30.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

private let experienceArticleServlet = "ExperienceArticleServlet"

private let isMessageCell = "IsMessageCell"
private let noneMessageCell = "NoneMessageCell"
private let loadingCell = "LoadingCell"

class CommentDialogViewController: UIViewController {
    
    var dialogArticle : ExperienceArticle?
    private var comments = [ArticleComment]() // 留言
    private var isNew = false
    private var bottomConstraint : NSLayoutConstraint?
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentInputTextField: UITextField!
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
        bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: dialogView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        view.addConstraint(bottomConstraint!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 留言數不等於 0 連線取資料 ...
        guard let article = dialogArticle else { return }
        if article.commentCount != 0 { getArticleComment(postId: article.postId) }
        commentInputTextField.becomeFirstResponder()
    }
    
    @objc private func handleKeyboardNotification(notification : Notification) {
        guard let userInfo = notification.userInfo else{ return }
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height + 40 : 0
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            //..
        }
    }

    @objc private func endEditing(){
        self.commentInputTextField.resignFirstResponder()
    }

    @IBAction func sendBtnTapped(_ sender: Any) {
        guard let text = commentInputTextField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else {
            commentInputTextField.text?.removeAll()
            return
        }
        endEditing()
        guard let account = userAccount, let article = self.dialogArticle else { return }
        self.setArticleComment(account: account, postId: article.postId, content: text)
        self.commentInputTextField.text?.removeAll()
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        endEditing()
    }
    
    private func setGesture() {
        self.commentTableView.isUserInteractionEnabled = true
        let tableVIewGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tableVIewGesture.cancelsTouchesInView = false
        self.commentTableView.addGestureRecognizer(tableVIewGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isNew, let controller = segue.destination as? PhotoItemViewController {
            controller.article = dialogArticle
        }
    }
}



extension CommentDialogViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = dialogArticle?.postContent ?? "無內文"
            return cell
        
        default:

            if comments.count == 0 {

                guard let article = dialogArticle else { return UITableViewCell() }
                switch article.commentCount {
                case 0:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: noneMessageCell, for: indexPath) as? NoneMessageTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
                    return cell
                default:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: loadingCell, for: indexPath) as? LoadingTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.loadingView.startAnimating()
                    return cell
                }
            }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: isMessageCell, for: indexPath) as? ArticleToMessageTableViewCell else {
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
            cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))

            return cell
        }
    }
}



extension CommentDialogViewController {
    
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
            }
            self.commentTableView.reloadData()
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
    
    // 留言
    private func setArticleComment(account: String, postId: Int, content: String) {
        
        let request: [String: Any] = ["experienceArticle": "setExperienceComment",
                                      "userName": account,
                                      "postId": postId,
                                      "commentStr": content]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let commentResult = result as? Int else { return }
            
            if commentResult > 0 { }
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
                self.commentTableView.reloadData() // 第一筆
            } else {
                self.commentTableView.insertRows(at: [indexPath], with: .fade) // 非第一筆
            }
            // 畫面拉到最下面
            self.commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            // 修改資料留言數 , let commentCount = article.commentCount
            if let commentCount = self.dialogArticle?.commentCount {
                self.dialogArticle?.commentCount = commentCount + 1
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
                if let commentCell = self.commentTableView.cellForRow(at: indexPath) {
                    commentCell.alpha = 0.5
                    UIView.animate(withDuration: 1) {
                        commentCell.alpha = 1
                    }
                }
            }
        }
    }
}

