//
//  ArticleTableViewController.swift
//  Master
//
//  Created by Diego on 2018/7/26.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit


private let experienceArticleServlet = "ExperienceArticleServlet"
private let postsCell = "PostsArticleCell"

class ArticleTableViewController: UITableViewController {
    
    @IBOutlet var articleLoadingView: UIView!
    @IBOutlet weak var articleLoadingIndicator: UIActivityIndicatorView!
    
    private var loginId = "" // 目前顯示該頁所使用的帳號
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 準備讀取畫面
        tableView.backgroundView = articleLoadingView
        // 繼承 UITableViewController 關係 refreshControl 已經包含在內
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "刷新中...", attributes: [.foregroundColor : UIColor.gray])
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        // 關閉點擊延遲
        tableView.delaysContentTouches = false
        // 存入初始化狀態
        if let id = userAccount {
            loginId = id // 存入顯示該頁所使用的帳號
        }
        // 註冊發布文章通知
        NotificationCenter.default.addObserver(self, selector: #selector(postNewArticle(noti:)), name: .postNewArticle, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 畫面移動到頂端
        let topRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        self.tableView.scrollRectToVisible(topRect, animated: false)
        // 檢查目前登入的帳號是否跟讀取時的帳號一致, 否則重新整理(包括登出狀態)
        var account = ""
        if let userAccount = userAccount { account = userAccount }
        if account != loginId {
            loginId = account
            reloadArticleView()
        }
    }
    
    // 偵測到發佈新文章執行
    @objc func postNewArticle(noti: Notification) {
        
        if let userInfo = noti.userInfo, let newArticle = userInfo["newArticle"] as? ExperienceArticle {
            ArticleData.shared.info.insert(newArticle, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    // 下拉刷新畫面執行
    @objc func pullToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            defer { self.refreshControl?.endRefreshing() }
            self.reloadArticleView()
        }
    }
    
    private func reloadArticleView() {
        var account = ""
        if let userAccount = userAccount { account = userAccount }
        self.getExperienceArticle(account: account)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if ArticleData.shared.info.count > 0 {
            tableView.backgroundView?.isHidden = true
            articleLoadingIndicator.stopAnimating()
        } else {
            tableView.backgroundView?.isHidden = false
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ArticleData.shared.info.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: postsCell, for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        // 發文者大頭照
        if let data = ArticleData.shared.info[indexPath.row].postPortrait {
            cell.postsPortraitImage.image = UIImage(data: data)
        } else {
            cell.postsPortraitImage.getUserPortrait(account: ArticleData.shared.info[indexPath.row].userId, index: indexPath.row)
        }
        // 內容貼圖
        if let data = ArticleData.shared.info[indexPath.row].postPhoto {
            cell.postsContentImage.image = UIImage(data: data)
        } else {
            cell.postsContentImage.getArticlePhoto(postId: ArticleData.shared.info[indexPath.row].postId, index: indexPath.row)
        }
        
        cell.postsNameLabel.text = ArticleData.shared.info[indexPath.row].userName
        cell.postsDateLabel.text = ArticleData.shared.info[indexPath.row].postTime
        cell.postsContentLabel.text = ArticleData.shared.info[indexPath.row].postContent
        cell.postsLikeNumberLabel.text = "\(ArticleData.shared.info[indexPath.row].postLikes)"
        
        if let text = ArticleData.shared.info[indexPath.row].commentCount {
            cell.postsTalkNumberLabel.text = text
        } else {
            getExperienceCommentCount(postId: ArticleData.shared.info[indexPath.row].postId, label: cell.postsTalkNumberLabel, index: indexPath.row)
        }
        // 點讚狀態
        if ArticleData.shared.info[indexPath.row].postLike {
            cell.postsLikeButton.tintColor = UIColor.blue
        } else {
            cell.postsLikeButton.tintColor = UIColor.black
        }
        
        return cell
    }
    
    @IBAction func clickAddNewArticle(_ sender: UIBarButtonItem) {
        
        guard checkLogin() else { return }
        
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "AddNewArticleVC")
        let rootViewController = self.view.window?.rootViewController
        rootViewController?.present(loginView, animated: true, completion: nil)
        
    }
    
    // 點讚
    @IBAction func clickLink(_ sender: UIButton) {
        
        guard checkLogin() else { return }
        
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)
        
        guard let index = indexPath, let account = userAccount else { return }
        
        let isLike = ArticleData.shared.info[index.row].postLike
        changeExperiencePostLike(account: account, postId: ArticleData.shared.info[index.row].postId, isLike: !isLike, index: index.row)
        
        ArticleData.shared.info[index.row].postLike = !isLike
        
        guard let cell = tableView.cellForRow(at: index) as? ArticleTableViewCell else { return }
        
        var likeNumber = ArticleData.shared.info[index.row].postLikes
        
        if isLike {
            cell.postsLikeButton.tintColor = UIColor.black
            likeNumber -= 1
        } else {
            cell.postsLikeButton.tintColor = UIColor.blue
            likeNumber += 1
        }
        cell.postsLikeNumberLabel.text = "\(likeNumber)"
        ArticleData.shared.info[index.row].postLikes = likeNumber
    }
    
    // 留言
    @IBAction func clickTalk(_ sender: UIButton) {
        
        guard checkLogin() else { return }
        // 拿到目前點擊的 IndexPath
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        // 準備目的地
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: "ActicleDetailVC")
        // 準備傳值, 及
        if let detailViewController = (detailView as? UINavigationController)?.topViewController as? ArticleDetailViewController,  let indexPath = self.tableView.indexPathForRow(at: point) {
            
            detailViewController.articleDetail = ArticleData.shared.info[indexPath.row]
            self.present(detailView, animated: true, completion: nil)
            return
        }

        // TODO: - 換頁失敗?
    }
    
    private func checkLogin() -> Bool {
        
        var result: Bool
        if userAccount == nil {
            result = false
            Alert.shared.buildDoubleAlert(viewController: self, alertTitle: "您還沒有登入", alertMessage: nil, actionTitles: ["繼續逛逛","登入"], firstHandler: { (action) in
                // 繼續逛逛
            }) { (action) in
                // 登入
                presentLoginView(view: self)
            }
        } else {
            result = true
        }
        return result
    }
    
    
    
    // MARK: - Connect DataBase Methods
    
    // 拿到所有文章內容所需顯示資料, 不含圖片
    private func getExperienceArticle(account: String) {
        
        let request: [String: Any] = ["experienceArticle": "getExperiences",
                                      "userId": account]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            let decoder = JSONDecoder()
            
            let results = try? decoder.decode([ExperienceArticle].self, from: data)
            
            guard let result = results else { return }
            
            if result.count != 0 {
                ArticleData.shared.info = result
                self.tableView.reloadData()
            }
        }
    }
    // 拿到文章留言數量
    private func getExperienceCommentCount(postId: Int, label: UILabel, index: Int) {
        
        let request: [String: Any] = ["experienceArticle": "getExperienceCommentCount",
                                      "postId": postId]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
            
            guard error == nil, let data = data else {
                ArticleData.shared.info[index].commentCount = "0 則留言"
                label.text = "0 則留言"
                return
            }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results, let resultInt = result as? Int else {
                ArticleData.shared.info[index].commentCount = "0 則留言"
                label.text = "0"
                return
            }
            
            label.text = "\(resultInt) 則留言"
            ArticleData.shared.info[index].commentCount = "\(resultInt) 則留言"
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
}










