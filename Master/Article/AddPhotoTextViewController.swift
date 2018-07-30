//
//  AddPhotoTextViewController.swift
//  Master
//
//  Created by winni on 2018/7/29.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import Photos

private let photoServlet = "photoServlet"
private let experienceArticleServlet = "ExperienceArticleServlet"

class AddPhotoTextViewController: UIViewController {
    
    @IBOutlet weak var newArticleImageView: UIImageView!
    @IBOutlet weak var newArticleTextView: UITextView!
    
    private let addPhotoPicker = UIImagePickerController()
    private let addPhotoCropper = UIImageCropper(cropRatio: 16/9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 相機, 相簿相關
        addPhotoCropper.delegate = self
        addPhotoCropper.picker = addPhotoPicker
        addPhotoCropper.cropButtonText = "Crop"
        addPhotoCropper.cancelButtonText = "Retake"
        
//        // 請求相機授權？應該不用？
//        PHPhotoLibrary.requestAuthorization { (status) in
//            print("PHPhotoLibrary.requestAuthorization: \(status.rawValue)")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addPhoto(_ sender: Any) {
        
        Alert.shared.buildPhotoAlert(viewController: self, takePic: { (action) in
            self.addPhotoPicker.sourceType = .camera
            self.present(self.addPhotoPicker, animated: true, completion: nil)
        }) { (action) in
            self.addPhotoPicker.sourceType = .photoLibrary
            self.present(self.addPhotoPicker, animated: true, completion: nil)
        }
    }
    
    // 推送新文章
    @IBAction func pushNewArticle(_ sender: Any) {
        guard let account = userAccount else { return }
        pushArticlePhoto(account: account)
    }
    
    // 清空畫面
    @IBAction func deleteBtAction(_ sender: Any) {
        newArticleTextView.text = ""
        newArticleImageView.image = nil
    }
    
    
    
 // MARK: - Connect DataBase Methods
    
    // 開始上傳文章圖片
    private func pushArticlePhoto(account: String) {
        
        guard let articleImage = newArticleImageView.image else { return }
        guard let imageData = UIImageJPEGRepresentation(articleImage , 1) else { return }
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
                self.pushArticleText(account: account, photoId: photoId)
            } else {
                self.showFailAlert()
            }
        }
    }
    
    // 開始上傳文章內容
    private func pushArticleText(account:String, photoId: Int) {
        
        let text = newArticleTextView.text ?? ""
        
        let request : [String : Any] = ["experienceArticle": "insertExperience",
                                        "user_id": account,
                                        "content": text,
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
                print("成功新增")
                // TODO: - 回到上一頁
            } else {
                self.showFailAlert()
            }
        }
    }
    
    private func showFailAlert() {
        
        Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "Error") { (action) in
            print("上傳失敗")
        }
    }

}

extension AddPhotoTextViewController : UIImageCropperProtocol{
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        // 下面視做壓縮圖片的動作 croppedImage?.resize(maxWidthHeight: imageView.frame.height) 然後前面要宣告給下面裁切 保存用
        let image =  croppedImage?.resize(maxWidthHeight: newArticleImageView.frame.height) // 宣告image為一個常數 讓相片壓縮完
        newArticleImageView.image = image//imageView 裡面有一個image 屬性 現在這個屬性是croppedImage(才切後的相片）

    }
    
}


