//
//  Common.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

//Only put "let" property over here
//if you want to put variable property put it in singleton

// Connect DB URL
let urlString = "http://127.0.0.1:8080/Master/"


// Singleton
class Common{
    static let shared = Common()
    private init(){}
    typealias alertHandler = (UIAlertAction) -> ()
    
    // Double Action Alert
    func buildDoubleAlert(viewController : UIViewController,alertTitle : String?,alertMessage : String?,actionTitles : [String],firstHandler : @escaping alertHandler,secondHandler : @escaping alertHandler){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let firstAlertAction = UIAlertAction(title: actionTitles[0], style: .default, handler: firstHandler)
        let secondAlertAction = UIAlertAction(title: actionTitles[1], style: .default, handler: secondHandler)
        alertController.addAction(firstAlertAction)
        alertController.addAction(secondAlertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // Triple Action Alert
    func buildTripleAlert(viewController : UIViewController,alertTitla : String?,actionTitles : [String],firstAction : @escaping alertHandler,secondAction : @escaping alertHandler,thirdAction : @escaping alertHandler){
        
        let alertController = UIAlertController(title: alertTitla, message: nil, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: actionTitles[0], style: .default, handler: firstAction)
        let secondAction = UIAlertAction(title: actionTitles[1], style: .default, handler: secondAction)
        let thirdAction = UIAlertAction(title: actionTitles[2], style: .default, handler: thirdAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // Photo Alert
    func buildPhotoAlert(viewController : UIViewController,takePic : @escaping alertHandler,pickPic : @escaping alertHandler){
        let alertController = UIAlertController(title: "選擇照片來源", message: nil, preferredStyle: .actionSheet)
        let takePicture = UIAlertAction(title: "相機", style: .default, handler: takePic)
        let pickFromAlbum = UIAlertAction(title: "從相簿選擇相片", style: .default, handler: pickPic)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(takePicture)
        alertController.addAction(pickFromAlbum)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension UIImageView{
    func setRoundImage(){
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
    }
}

extension UITableView{
    func setCellAutoRowHeight(){
        self.estimatedRowHeight = 100
        self.rowHeight = UITableViewAutomaticDimension
    }
}

extension UILabel{
    func setLableMultipleLine(){
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
    }
}









