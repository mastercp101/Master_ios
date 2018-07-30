//
//  PhotoItemViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/30.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class PhotoItemViewController: UIViewController {

    @IBOutlet weak var phototScrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var article : ExperienceArticle?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        setImageView()
        setNav()
        
    }
    deinit {
        UIApplication.shared.statusBarStyle = .default
    }
    
    @IBAction func readMoreBtnTapped(_ sender: Any) {
        let nextVC = setCommentVC()
        self.present(nextVC, animated: true)
    }
    
    @IBAction func likeBtnTapped(_ sender: Any) {
    }
    
    @IBAction func commentsBtnTapped(_ sender: Any) {
        let nextVC = setCommentVC() as! CommentDialogViewController
        nextVC.commentInputTextField.becomeFirstResponder()
        self.present(nextVC, animated: true)
    }
    
    private func setCommentVC() -> UIViewController{
        let commentVC = UIStoryboard(name: "Photo", bundle: nil).instantiateViewController(withIdentifier: "CommentDialogVC")
        commentVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        commentVC.modalPresentationStyle = .overCurrentContext
        commentVC.modalTransitionStyle = .crossDissolve
        return commentVC
    }
    
    private func setNav(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    private func setImageView(){
        phototScrollView.minimumZoomScale = 1.0
        phototScrollView.maximumZoomScale = 3.0
        if let article = article {
            let image = UIImage(data: article.postPhoto!)
            photoImageView.image = image
        }else{
            photoImageView.image = UIImage(named: "user_default_bkgd")
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension PhotoItemViewController : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
}
