//
//  AddPhotoTextViewController.swift
//  Master
//
//  Created by winni on 2018/7/29.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import Photos

private let THINK_TEXT = "在想些什麼?"
private let photoServlet = "photoServlet"
private let experienceArticleServlet = "ExperienceArticleServlet"

class AddPhotoTextViewController: UIViewController {
    
    // 轉轉轉元件編號
    private let loadingViewTag = 9527
    // 文章圖片壓縮比
    private let compressionRatio: CGFloat = 0.7
    
    @IBOutlet weak var postPortrait: UIImageView!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var newArticleImageView: UIImageView!
    @IBOutlet weak var newArticleTextView: UITextView!
    @IBOutlet weak var bottomLayout: NSLayoutConstraint! // Layout
    
    private let addPhotoPicker = UIImagePickerController()
    private let addPhotoCropper = UIImageCropper(cropRatio: 8/6)
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // User name and portrait
        if let name = userName, let data = userPortrait {
            postName.text = name
            postPortrait.image = UIImage(data: data)
        } else if let account = userAccount {
            getUserInfo(account: account)
        }
        // Prepare textView
        newArticleTextView.textContainer.lineFragmentPadding = 15
        newArticleTextView.delegate = self
        newArticleTextView.textColor = .gray
        newArticleTextView.text = THINK_TEXT
        // Prepare camera and photo library
        addPhotoCropper.delegate = self
        addPhotoCropper.picker = addPhotoPicker
        addPhotoCropper.cropButtonText = "Crop"
        addPhotoCropper.cancelButtonText = "Retake"
        // 監聽鍵盤事件
        NotificationCenter.default.addObserver(self, selector: #selector(moveBottomViewUp(_:)), name: .UIKeyboardWillShow, object: nil)
        //        // 請求相機授權？應該不用？
        //        PHPhotoLibrary.requestAuthorization { (status) in
        //            print("PHPhotoLibrary.requestAuthorization: \(status.rawValue)")
        //        }
    }

    @objc func moveBottomViewUp(_ aNotification: Notification) {
        let info = aNotification.userInfo
        let sizeValue = info![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let size = sizeValue.cgRectValue.size
        let height = size.height
        self.bottomLayout.constant = height
        UIView.animate(withDuration: 0.23){
            self.view.layoutIfNeeded()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 相機
    @IBAction func addCameraPhoto(_ sender: UIButton) {
        endEdit()
        self.addPhotoPicker.sourceType = .camera
        self.present(self.addPhotoPicker, animated: true, completion: nil)
    }
    
    // 相簿
    @IBAction func addLibraryPhoto(_ sender: UIButton) {
        endEdit()
        self.addPhotoPicker.sourceType = .photoLibrary
        self.present(self.addPhotoPicker, animated: true, completion: nil)
    }
    
    // 發布
    @IBAction func pushNewArticle(_ sender: UIBarButtonItem) {
        endEdit()
        
        guard let image = newArticleImageView.image else {
            showAlert(message: "尚未選擇圖片")
            return
        }
        guard let text = newArticleTextView?.text.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty, text != THINK_TEXT else {
            showAlert(message: "尚未編輯文章")
            return
        }
        guard let account = userAccount else {
            showAlert(message: "尚未登入")
            return
        }
        Alert.shared.buildDoubleAlert(viewController: self, alertTitle: "確定發布?", alertMessage: nil, actionTitles: ["取消","確定"], firstHandler: { (action) in
            // nope ...
        }) { (action) in
            self.prepareLoadingView()
            self.pushArticlePhoto(account: account, article: text, photo: image)
        }
    }
    
    // 點擊下方小灰條
    @IBAction func clickViewEndEdit(_ sender: UITapGestureRecognizer) {
        endEdit()
    }
    
    // 回到上一頁
    @IBAction func goBackToArticleHome(_ sender: UIBarButtonItem) {
        endEdit()
        if let text = newArticleTextView?.text.trimmingCharacters(in: .whitespacesAndNewlines),
            !text.isEmpty, text != THINK_TEXT || newArticleImageView.image != nil {
            
            Alert.shared.buildDoubleAlert(viewController: self, alertTitle: "您即將離開", alertMessage: nil, actionTitles: ["捨棄貼文", "繼續編輯"], firstHandler: { (action) in
                self.dismiss(animated: true)
            }) { (action) in
                // nope ...
            }
            return
        }
        dismiss(animated: true)
    }
    
    // 準備轉轉畫面
    private func prepareLoadingView() {
        
        if let view = self.view.viewWithTag(loadingViewTag) {
            if view.alpha == 0 {
                UIView.animate(withDuration: 0.15) { view.alpha = 0.3 }
            }
            return
        }
        // 背景
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.backgroundColor = .black
        view.alpha = 0
        view.tag = loadingViewTag
        // 轉轉轉
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.frame = CGRect(origin: .zero, size: self.view.frame.size)
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        activity.startAnimating()
        // 加入背景
        view.addSubview(activity)
        self.view.addSubview(view)
        UIView.animate(withDuration: 0.15) {
            self.view.viewWithTag(self.loadingViewTag)?.alpha = 0.3
        }
    }
    
    // 結束鍵盤
    private func endEdit() {
        self.view.endEditing(true)
        bottomLayout.constant = 0
        UIView.animate(withDuration: 0.23, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    
    
 // MARK: - Connect DataBase Methods
    
    // 開始上傳文章圖片
    private func pushArticlePhoto(account: String, article: String, photo: UIImage) {
        
        guard let imageData = UIImageJPEGRepresentation(photo , compressionRatio) else {
            return
        }
        let base64 = imageData.base64EncodedString()
        
        let request = ["action": "insert", "photo": base64, "user_id": account]
        
        Task.postRequestData(urlString: urlString + photoServlet, request: request) { (error, data) in

            guard error == nil, let data = data else{
                self.showFailAlert()
                return
            }
            
            guard let result = String(data: data, encoding: .utf8), let photoId = Int(result) else {
                self.showFailAlert()
                return
            }
            if photoId > 0 {
                self.pushArticleText(account: account, photoId: photoId, article: article, photoData: imageData)
            } else {
                self.showFailAlert()
            }
        }
    }
    
    // 開始上傳文章內容
    private func pushArticleText(account:String, photoId: Int, article: String, photoData: Data) {
        
        let request : [String : Any] = ["experienceArticle": "insertExperience",
                                        "user_id": account,
                                        "content": article,
                                        "photo_id": photoId]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
            
            guard error == nil, let data = data else{
                self.showFailAlert()
                return
            }
            
            guard let result = String(data: data, encoding: .utf8), let pushResult = Int(result) else {
                self.showFailAlert()
                return
            }
 
            if pushResult != 0 {

                // 現在時間
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let time = formatter.string(from: Date())
                // 準備返回的文章物件
                let returnData = ExperienceArticle(postId: pushResult, userId: account, postContent: article, postTime: time, photoId: photoId, userName: self.postName.text ?? account, postLike: false, postLikes: 0, postPortrait: userPortrait, postPhoto: photoData, commentCount: 0)
                // 回到上一頁, 並回傳
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: .postNewArticle, object: nil, userInfo: ["newArticle" : returnData])
                }
            } else {
                self.showFailAlert()
            }
        }
    }
    // 拿到自己的大頭照及名字
    private func getUserInfo(account: String) {
        
        let request : [String : Any] = ["experienceArticle": "experienceUserData",
                                        "userId": account]
        
        Task.postRequestData(urlString: urlString + experienceArticleServlet, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let decoder = JSONDecoder()
            let results = try? decoder.decode(User.self, from: data)
            
            guard let result = results else { return }
            
            if let base64 = result.userPortraitBase64, let data = Data(base64Encoded: base64) {
                UserFile.shared.saveUserPortrait(data: data)
                self.postPortrait.image = UIImage(data: data)
            } else {
                self.postPortrait.image = UIImage(named: "user_default_por")
            }
           
            if let name = result.userName {
                UserFile.shared.setUserName(name: name)
                self.postName.text = name
            } else {
                self.postName.text = account
            }
        }
    }
    
    // AAAAAAlert
    private func showFailAlert() {
        self.view.viewWithTag(loadingViewTag)?.alpha = 0
        Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "Error") { (action) in
            print("AddPhotoTextViewController: 文章上傳失敗")
        }
    }
    private func showAlert(message: String) {
        Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: message) { (action) in }
    }
    
}


extension AddPhotoTextViewController : UIImageCropperProtocol {
    
    
//    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
//
//        let image =  croppedImage?.resize(maxWidthHeight: newArticleImageView.frame.height) // 宣告image為一個常數 讓相片壓縮完
//        newArticleImageView.image = image//imageView 裡面有一個image 屬性 現在這個屬性是croppedImage(才切後的相片）
//
//    }
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        
        guard let image = croppedImage else{ return }
        
        guard image.size.height * image.size.width > 375 * 250 else {
           
            newArticleImageView.image = image
            return
        }
        
        let size = __CGSizeApplyAffineTransform((croppedImage?.size)!, CGAffineTransform(scaleX: 0.5, y: 0.5))
        let hasAlpha = false
        let scale : CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        
        UIGraphicsEndImageContext()
        newArticleImageView.image = scaledImage
    }
    
}

extension AddPhotoTextViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == THINK_TEXT {
            textView.textColor = .black
            textView.text.removeAll()
        }
    }
}











