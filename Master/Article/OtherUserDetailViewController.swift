//
//  OtherUserDetailViewController.swift
//  Master
//
//  Created by Diego on 2018/8/6.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class OtherUserDetailViewController: UIViewController {
    
    @IBOutlet weak var otherBackground: UIImageView!
    @IBOutlet weak var otherPortrait: UIImageView!
    @IBOutlet weak var otherName: UILabel!
    @IBOutlet weak var otherProfile: UILabel!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var infoView: UIView!
    
    var otherUserId: String? // 傳遞過來的資料
    var otherUserInfo: User? // 下載的資料
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 隱藏畫面, show轉轉轉
        infoView.alpha = 0
        loadingView.hidesWhenStopped = true

        guard let userId = otherUserId else { return }
        getUserInfo(account: userId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        goBack()
    }
    @IBAction func clickBackgroundView(_ sender: UITapGestureRecognizer) {
        goBack()
    }
    @IBAction func otherUserInfoGoBack(segue: UIStoryboardSegue) {
        goBack()
    }

    
    @IBAction func clickGoTalk(_ sender: UIButton) {
    
        
        // ... 聊聊
        
        
    }
    
    
    private func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func perpaerView() {
        otherName.text = otherUserInfo?.userName
        otherProfile.text = otherUserInfo?.userProfile
        
        if let profileBase64 = otherUserInfo?.userPortraitBase64, let profile = Data(base64Encoded: profileBase64) {
            otherPortrait.image = UIImage(data: profile)
        } else {
            otherPortrait.image = UIImage(named: "user_default_por")
        }
        
        if let bkgdBase64 = otherUserInfo?.userBackgroundBase64, let bkgd = Data(base64Encoded: bkgdBase64) {
            otherBackground.image = UIImage(data: bkgd)
        } else {
            otherBackground.image = UIImage(named: "user_default_bkgd")
        }
        loadingView.stopAnimating()
        UIView.animate(withDuration: 0.15) {
            self.infoView.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let controller = (segue.destination as? UINavigationController)?.topViewController as? OtherUserInfoTableViewController {
            controller.otherUserInfo = self.otherUserInfo
        }
    }
    
    
 // MARK: - Connect DataBase Methods
    
    private func getUserInfo(account: String) {
        
        let request: [String: Any] = ["action": "findById", "account": account]
        Task.postRequestData(urlString: urlString + urlUserInfo , request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let decoder = JSONDecoder()
            let results = try? decoder.decode(User.self, from: data)
            guard let result = results else { return }
            
            self.otherUserInfo = result
            self.perpaerView()
        }
    }
    
}
