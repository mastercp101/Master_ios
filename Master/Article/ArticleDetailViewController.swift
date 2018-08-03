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
    // 留言資訊
    var comments = [ArticleComment]()
    // tableView
    var tableView: UITableView?
    // Bottom Layout
    @IBOutlet weak var viewBottomLayout: NSLayoutConstraint!
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 找到 TableView
        for view in self.view.subviews {
            if view is UITableView, let tableView = view as? UITableView { self.tableView = tableView }
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
        self.view.endEditing(true)
        viewBottomLayout.constant = 0
        UIView.animate(withDuration: 0.23, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackToArticleHome(_ sender: UIBarButtonItem) {
        endEdit()
        self.dismiss(animated: true) {
            ("dismiss")
        }
    }
    
    
 // MARK: - Connect DataBase Methods
    
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
            if let data = ArticleData.shared.info[index].postPortrait {
                cell.articleDetailPortrait.image = UIImage(data: data)
            } else {
                cell.articleDetailPortrait.image = UIImage(named: "user_default_por")
            }
            cell.articleDetailName.text = ArticleData.shared.info[index].userName
            cell.articleDetailDate.text = ArticleData.shared.info[index].postTime
            cell.articleDetailContent.text = ArticleData.shared.info[index].postContent
            if let photoData = ArticleData.shared.info[index].postPhoto {
                cell.articleDetailPhoto.image = UIImage(data: photoData)
            } else {
                cell.articleDetailPhoto.image = UIImage(named: "user_default_por")
            }
            cell.articleDetailLikes.text = "\(ArticleData.shared.info[index].postLikes)"
            cell.articleDetailTalks.text = "\(ArticleData.shared.info[index].commentCount ?? 0) 則留言"
            return cell
            
        default:
            
            if comments.count == 0 {
                
                guard let index = selectArticleIndex else { return UITableViewCell() }
                switch ArticleData.shared.info[index].commentCount {
                case 0:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: noneMessageCell, for: indexPath) as? NoneMessageTableViewCell else {
                        return UITableViewCell()
                    }
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
            
            if let image = comments[index].user_Portrait {
                cell.messageImageView.image = UIImage(data: image)
            } else if let userId = comments[index].user_id {
                getCommentPortrait(target: cell.messageImageView, account: userId, index: index)
            } else {
                cell.messageImageView.image = UIImage(named: "user_default_por")
            }
       
            cell.messageNameLabel.text = comments[index].user_name
            cell.messageDateLabel.text = comments[index].comment_time
            cell.messageDetailLabel.text = comments[index].comment_content
            return cell
        }
    }
 
}


