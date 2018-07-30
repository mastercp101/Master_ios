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
    
    let test = [["beagle", "名字", "2018-01-01", "內文內文內文內文內文\n內文內文內文", "beagle", "1515", "12"],["bordercollie", "名字2", "2018-01-11", "內文內文內文內文內文內文內文內文內12312內文內文內文內文內文\n內文內文內文", "bordercollie", "1215", "11"],["bulldog", "名字66", "2018-66-66", "666666文內文內文內文內文\n內文內文內文", "bulldog", "166", "66"], ["bulldog", "名字1212", "2018-1231", "666666文內文內1231233123文內文內文\n內文內文內文", "shiba", "123", "12"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // 繼承 UITableViewController 關係 refreshControl 已經包含在內
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "刷新中...", attributes: [.foregroundColor : UIColor.gray])
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        // 關閉點擊延遲
        tableView.delaysContentTouches = false
        // 準備連線
        var account = ""
        if let userAccount = userAccount { account = userAccount }
        getExperienceArticle(account: account)
    }
    
    // TODO: - 刷新畫面
    @objc func pullToRefresh() {
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            defer { self.refreshControl?.endRefreshing() }
            var account = ""
            if let userAccount = userAccount { account = userAccount }
            self.getExperienceArticle(account: account)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
        }
//        else if let userId = ArticleData.shared.info[indexPath.row].userId {
//            cell.postsPortraitImage.getUserPortrait(account: userId, index: indexPath.row)
//        }
        let userId = ArticleData.shared.info[indexPath.row].userId
        cell.postsPortraitImage.getUserPortrait(account: userId, index: indexPath.row)
        
        // 內容貼圖
        if let data = ArticleData.shared.info[indexPath.row].postPhoto {
            cell.postsContentImage.image = UIImage(data: data)
        }
//        else if let postId = ArticleData.shared.info[indexPath.row].postId {
//            cell.postsContentImage.getArticlePhoto(postId: postId, index: indexPath.row)
//        }
        let postId = ArticleData.shared.info[indexPath.row].postId
        cell.postsContentImage.getArticlePhoto(postId: postId, index: indexPath.row)
        
        cell.postsNameLabel.text = ArticleData.shared.info[indexPath.row].userName
        cell.postsDateLabel.text = ArticleData.shared.info[indexPath.row].postTime
        cell.postsContentLabel.text = ArticleData.shared.info[indexPath.row].postContent
        cell.postsLikeNumberLabel.text = "\(ArticleData.shared.info[indexPath.row].postLikes)"
        
        if let text = ArticleData.shared.info[indexPath.row].commentCount {
            cell.postsTalkNumberLabel.text = text
        }
//        else if let postId = ArticleData.shared.info[indexPath.row].postId {
//            getExperienceCommentCount(postId: "\(postId)", label: cell.postsTalkNumberLabel, index: indexPath.row)
//        }
        else {
            cell.postsTalkNumberLabel.text = "0 則留言"
        }
//        let postId = ArticleData.shared.info[indexPath.row].postId
        getExperienceCommentCount(postId: "\(postId)", label: cell.postsTalkNumberLabel, index: indexPath.row)
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func clickLink(_ sender: UIButton) {

        
    }
    
    @IBAction func clickTalk(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)
        print("\(indexPath?.row ?? -1)")
    }
    
    
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
    
    
    private func getExperienceCommentCount(postId: String, label: UILabel, index: Int) {
        
        let request: [String: Any] = ["experienceArticle": "getExperienceCommentCount",
                                      "postId": postId]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
        
            guard error == nil, let data = data else {
                ArticleData.shared.info[index].commentCount = "0 則留言"
                label.text = "0 則留言"
                return
            }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results, let resultString = result as? Int else {
                ArticleData.shared.info[index].commentCount = "0 則留言"
                label.text = "0"
                return
            }
            
            label.text = "\(resultString) 則留言"
            ArticleData.shared.info[index].commentCount = "\(resultString) 則留言"
        }
    }
}










