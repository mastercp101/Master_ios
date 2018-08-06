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
//哲維
//let urlString = "http://192.168.50.21:8080/Master/"
//峻亦
let urlString = "http://192.168.50.245:8080/Master/"
let urlUserInfo = "UserInfo"
let encoder = JSONEncoder()
let decoder = JSONDecoder()

var userAccount: String? // 使用者帳號, nil即沒登入
var userAccess: UserAccess = .none // *** 使用者權限 ***
var userProfessions = [Profession]() // 原汁原味 [Profession], 會在 User 資訊頁面存入
var userName: String? //  使用者名字
var userPortrait: Data? //  使用者的大頭照


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
    
    func downloadExperience(){
        // TODO: - Debug
//        let account = "billy"
        // TODO: - 正式版
        var account = ""
        if let userAccount = userAccount { account = userAccount }
        // 
        let urlStr = urlString + "ExperienceArticleServlet"
        let request : [String : Any] = ["experienceArticle":"getExperiences","userId":account]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error{
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data ,let decodedData = try? decoder.decode([ExperienceArticle].self, from: data) else{
                assertionFailure("Invalid Data")
                return
            }
            ArticleData.shared.info = decodedData
        }
    }
    
    // Alert User who didn't login
    func alertUserToLogin(viewController : UIViewController){
        Alert.shared.buildSingleAlert(viewConteoller: viewController, alertTitle: "您還未登入") { (alert) in
            let nextVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
            viewController.present(nextVC, animated: true, completion: nil)
        }
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
    func buildTripleAlert(viewController : UIViewController,alertTitla : String?,actionTitles : [String],useCancelAction : Bool,firstAction : @escaping alertHandler,secondAction : @escaping alertHandler,thirdAction : @escaping alertHandler){
        
        let alertController = UIAlertController(title: alertTitla, message: nil, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: actionTitles[0], style: .default, handler: firstAction)
        let secondAction = UIAlertAction(title: actionTitles[1], style: .default, handler: secondAction)
        let thirdAction = UIAlertAction(title: actionTitles[2], style: .default, handler: thirdAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        if useCancelAction{
            alertController.addAction(cancelAction)
        }
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

extension UIImageView {
    
    // 下載文章圖片
    func getArticlePhoto(postId: Int, index: Int) {
        let url = urlString + urlUserInfo
        let request : [String : Any] = ["action" : "getUserPostPhoto", "postId" : postId]
        let image = UIImage(named: "user_default_por")
        
        downloadImage(url, request: request, defaultImage: image, failHandler: { (data) in
            ArticleData.shared.info[index].postPhoto = data
        }) { (data) in
            ArticleData.shared.info[index].postPhoto = data
        }
    }
    
    // 下載大頭照
    func getUserPortrait(account: String, index: Int?) {
        let url = urlString + "CourseArticleServlet"
        let request = ["courseArticle" : "getPhotoByUserId", "userId" : account]
        let image = UIImage(named: "user_default_por")
        
        if let index = index {
            downloadImage(url, request: request, defaultImage: image, failHandler: { (data) in
                ArticleData.shared.info[index].postPortrait = data
                ChatItemSingleTon.shared.friendPortrait = UIImage(data: data!)
            }) { (data) in
                ArticleData.shared.info[index].postPortrait = data
                ChatItemSingleTon.shared.friendPortrait = UIImage(data: data!)
            }
        }else{
            downloadImage(url, request: request, defaultImage: image, failHandler: { (defaultImageData) in}) { (imageData) in}
        }
    }
    
    private typealias passHandler = (Data?) -> Void
    private typealias failHandler = (Data?) -> Void
    static var currentTasks = [String: URLSessionDataTask]()
    
    private func downloadImage(_ url: String,
                               request: [String:Any],
                               defaultImage: UIImage?,
                               failHandler: @escaping failHandler,
                               passHandler: @escaping passHandler) {
        
        // Check if we should cancel exist download task
        if let existTask = UIImageView.currentTasks[self.description] {
            existTask.cancel()
            UIImageView.currentTasks.removeValue(forKey: self.description)
            print("A exist task is canceled")
        }
        // Keep going to download process.
        let loadingView = prepareLoadingView()
        
        Task.postRequestData(urlString: url, request: request) { (error, data) in
            
            defer { DispatchQueue.main.async { loadingView.stopAnimating() } }
            
            guard error == nil, let data = data else {
                DispatchQueue.main.async { self.image = defaultImage }
                if let image = defaultImage, let data = UIImageJPEGRepresentation(image, 1.0) { failHandler(data) }
                return
            }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results, let resultString = result as? String else {
                DispatchQueue.main.async { self.image = defaultImage}
                if let image = defaultImage, let data = UIImageJPEGRepresentation(image, 1.0) { failHandler(data) }
                return
            }
            guard let dataImage = Data(base64Encoded: resultString) else {
                DispatchQueue.main.async { self.image = defaultImage }
                if let image = defaultImage, let data = UIImageJPEGRepresentation(image, 1.0) { failHandler(data) }
                return
            }
            passHandler(dataImage)
            DispatchQueue.main.async { self.image = UIImage(data: dataImage) }
            // Remove task from currentTasks
            UIImageView.currentTasks.removeValue(forKey: self.description) // 下載完成拿掉
        }
        loadingView.startAnimating()
    }
    
    private func prepareLoadingView() -> UIActivityIndicatorView { // 創造轉轉轉
        
        // Find out exist loadingView. 防止重複新增元件
        for view in self.subviews { // 去 Array 找有沒有要的東西
            if view is UIActivityIndicatorView {
                return view as! UIActivityIndicatorView
            }
        }
        // Create loadingView 都沒有創造一個新的給它
        let frame = CGRect(origin: .zero, size: self.frame.size)
        let result = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge) // 轉轉轉 Style
        result.frame = frame
        result.color = .blue
        result.hidesWhenStopped = true // 沒有再跑自動隱藏
        // autolayout 前身 autoresizing 可用於簡單的配置
        result.autoresizingMask = [.flexibleHeight , .flexibleWidth] // 讓元件隨依附元件的寬高做改變
        self.addSubview(result)
        return result
    }
    
}






