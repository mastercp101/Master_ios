//
//  Alert.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

//Only put "let" property over here
//if you want to put variable property put it in singleton

// Connect DB URL
//let urlString = "http://127.0.0.1:8080/Master/"
let urlString = "http://192.168.50.20:8080/Master/"
let urlUserInfo = "UserInfo"
let encoder = JSONEncoder()
let decoder = JSONDecoder()

var userAccount: String? // 使用者帳號, nil即沒登入
var userAccess: UserAccess = .none // *** 使用者權限 ***
var userProfessions = [Profession]() // 原汁原味 [Profession], 會在 User 資訊頁面存入

// Singleton

class Common{
    static let shared = Common()
    private init(){}
    
    // Manage Keyboard
    func addObserves(scrollView : UIScrollView){
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            guard let usernfo = notification.userInfo,
                let frame = (usernfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
                    return
            }
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + 20, right: 0)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    
    func removeObservers(viewController : UIViewController){
        NotificationCenter.default.removeObserver(viewController)
    }

}

class Alert{
    static let shared = Alert()
    private init(){}
    typealias alertHandler = (UIAlertAction) -> ()
    
    
    func buildSingleAlert(viewConteoller : UIViewController,alertTitle : String?,handler : @escaping alertHandler){
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(OKAction)
        viewConteoller.present(alertController, animated: true, completion: nil)
    }
    
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

extension UIImage{
    func base64() -> String?{
//        guard let imageData : Data = UIImagePNGRepresentation(self) else{
//            return nil
//        }
        
        guard let imageData : Data = UIImageJPEGRepresentation(self, 0.5) else{
            return nil
        }
        return imageData.base64EncodedString()
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

extension UIButton {
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x + 3, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x - 3, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
    }
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 15.0
        layer.add(pulse, forKey: nil)
    }
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.4
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
}







