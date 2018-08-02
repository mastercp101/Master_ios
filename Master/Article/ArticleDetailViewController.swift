//
//  ArticleDetailViewController.swift
//  Master
//
//  Created by Diego on 2018/8/2.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit


private let articleToMessageCell = "ArticleToMessageCell"
private let articleDetailCell = "ArticleDetailCell"

class ArticleDetailViewController: UIViewController {

    var articleDetail: ExperienceArticle?
    
    @IBOutlet weak var viewBottomLayout: NSLayoutConstraint!
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(moveBottomViewUp(_:)), name: .UIKeyboardWillShow, object: nil)
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
    
        self.dismiss(animated: true) {
            print("dismiss")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: articleDetailCell, for: indexPath) as? ArticleDetailTableViewCell else {
            return UITableViewCell()
        }
        


//        let postContent: String // 內文




//        var postLikes: Int // 讚 總數量
//
//        var postPortrait: Data?
//        var postPhoto: Data?
//        var commentCount: String?
        
        if let data = articleDetail?.postPortrait {
            cell.articleDetailPortrait.image = UIImage(data: data)
        } else {
            cell.articleDetailPortrait.image = UIImage(named: "user_default_por")
        }
        cell.articleDetailName.text = articleDetail?.userName
        cell.articleDetailDate.text = articleDetail?.postTime
        cell.articleDetailContent.text = articleDetail?.postContent
        if let photoData = articleDetail?.postPhoto {
            cell.articleDetailPhoto.image = UIImage(data: photoData)
        } else {
            cell.articleDetailPhoto.image = UIImage(named: "user_default_por")
        }
        cell.articleDetailLikes.text = "\(articleDetail?.postLikes ?? 0)"
        cell.articleDetailTalks.text = articleDetail?.commentCount ?? "0 則留言"
        
        return cell
    }
    
    

    

    
    
    
}


