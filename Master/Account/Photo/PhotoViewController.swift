//
//  PhotoViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    
    @IBOutlet weak var notPhotoLabel: UILabel!
    
    @IBOutlet weak var photoCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var fullScreenWidth : CGFloat?
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        prepareRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserPhotoData.shared.info.count == 0 {
            photoCollectionView.reloadData()
            downloadUserArticle()
        }
    }
    
    private func setCollectionView(){
        fullScreenWidth = UIScreen.main.bounds.width
        photoCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        photoCollectionViewFlowLayout.minimumLineSpacing = 5
        let collectionItemSize = fullScreenWidth! / 3 - 10
        photoCollectionViewFlowLayout.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
    }
    
    private func downloadUserArticle(){
        let urlStr = urlString + "ExperienceArticleServlet"
        let request : [String : Any] = ["experienceArticle":"getExperienceByUserID","user_id":userAccount!]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error {
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data ,let articles = try? decoder.decode([ExperienceArticle].self, from: data) else{
                assertionFailure("Invalid data")
                return
            }
            UserPhotoData.shared.info = articles
            
            if UserPhotoData.shared.info.count == 0 {
                self.notPhotoLabel.isHidden = false
            } else {
                self.notPhotoLabel.isHidden = true
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    // 加入夏拉重新整理
    private func prepareRefreshControl() {
        photoCollectionView.refreshControl = UIRefreshControl()
        photoCollectionView.refreshControl?.addTarget(self, action: #selector(refreshPhotoData), for: .valueChanged)
    }
    // 下拉刷新畫面執行
    @objc func refreshPhotoData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            defer { self.photoCollectionView.refreshControl?.endRefreshing() }
            self.downloadUserArticle()
        }
    }
    
}

extension PhotoViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserPhotoData.shared.info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! photoCollectionViewCell
        
        if let dataImage = UserPhotoData.shared.info[indexPath.row].postPhoto {
            cell.articleImageView.image = UIImage(data: dataImage)
        } else {
            cell.articleImageView.getUserPhotoWall(postId: UserPhotoData.shared.info[indexPath.row].postId, index: indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! photoCollectionViewCell
        UserPhotoData.shared.info[indexPath.row].postPhoto = UIImagePNGRepresentation(cell.articleImageView.image!)
        let nextVC = UIStoryboard(name: "Photo", bundle: nil).instantiateViewController(withIdentifier: "photoItemVC") as! PhotoItemViewController
        
        nextVC.selectIndex = indexPath.row
        nextVC.userEntrance = .photo
        
        let navigation = UINavigationController(rootViewController: nextVC)
        self.show(navigation, sender: self)
    }
    
}

class photoCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var articleImageView: UIImageView!
}

class UserPhotoData {
    
    static let shared = UserPhotoData()
    private init(){}
    
    var info = [ExperienceArticle]()
}







