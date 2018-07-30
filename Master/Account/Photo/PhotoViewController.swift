//
//  PhotoViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var photoCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var fullScreenWidth : CGFloat?
    var articles = [ExperienceArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        self.articles = ArticleData.shared.info
    }
    
    private func setCollectionView(){
        fullScreenWidth = UIScreen.main.bounds.width
        photoCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        photoCollectionViewFlowLayout.minimumLineSpacing = 5
        let collectionItemSize = fullScreenWidth! / 3 - 10
        photoCollectionViewFlowLayout.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
    }
    
    
}
extension PhotoViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! photoCollectionViewCell
        cell.articleImageView.getArticlePhoto(postId: articles[indexPath.row].postId, index: indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Photo", bundle: nil).instantiateViewController(withIdentifier: "photoItemVC") as! PhotoItemViewController
        nextVC.article = self.articles[indexPath.row]
        let navigation = UINavigationController(rootViewController: nextVC)
        self.show(navigation, sender: self)
    }
    
}

class photoCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var articleImageView: UIImageView!
    
}









