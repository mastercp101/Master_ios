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
        phototScrollView.minimumZoomScale = 1.0
        phototScrollView.maximumZoomScale = 3.0
        
        
        if let article = article {
//            print(article.photoId)
            let image = UIImage(data: article.postPhoto!)
            photoImageView.image = image
        }else{
            photoImageView.image = UIImage(named: "user_default_bkgd")
        }
        
    }
    
}
extension PhotoItemViewController : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
}
