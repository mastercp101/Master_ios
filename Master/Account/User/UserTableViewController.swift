//
//  UserTableViewController.swift
//  Master
//
//  Created by Diego on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

private let SGIN_OUT_TEXT = "您即將登出"

private let DEFAULT_USER_PORTRAIT = "user_default_por"
private let DEFAULT_USER_BACKGROUND = "user_default_bkgd"

private let imageCell = "UserImageCell"
private let nameCell = "UserNameCell"
private let infoCell = "UserInfoCell"
private let profileCell = "UserProfileCell"
private let professionCell = "UserProfessionCell"
private let sginOutCell = "UserSginOutCell"

class UserTableViewController: UITableViewController {
    
    // TODO: - 圖片相關 1
    private var selectUserImageType: selectUserImageType = .none
    private let userImagePicker = UIImagePickerController()
    private let userImageCropper = UIImageCropper(cropRatio: 1/1)
    private let userGroundPicker = UIImagePickerController()
    private let userGroundCropper = UIImageCropper(cropRatio: 18/10)
    
    private let infoTitle = ["身份","性別","地址","電話"]
    private var userPortrait: Data?
    private var userBackground: Data?
    
    @IBOutlet var userLoadingView: UIView!
    @IBOutlet weak var userLoadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: - 圖片相關 2
        userGroundCropper.delegate = self
        userGroundCropper.picker = userGroundPicker
        userGroundCropper.cropButtonText = "Crop"
        userGroundCropper.cancelButtonText = "Retake"
        userImageCropper.delegate = self
        userImageCropper.picker = userImagePicker
        userImageCropper.cropButtonText = "Crop"
        userImageCropper.cancelButtonText = "Retake"
        
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        tableView.backgroundView = userLoadingView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // TODO: - 網路檢查 ?
        
        guard UserData.shared.info.count != 0 else {

            // TODO: - DeBug
            userAccess = .coach
            UserData.shared.info = [["image"],["名字"],["身份","性別","地址","電話"],
                                    ["自我介紹"],["技能","技能2","技能3"],["SginOut"]]
            
            // TODO: - 正式版
//            guard let account = userAccount else {
//                UserData.shared.info = [["image"],["nil"],["nil","nil","nil","nil"],["nil"],["out"]]
//                return
//            }
//            getUserInfo(account: account)
            return
        }
        tableView.reloadData() // 否則重新整理
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
 // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if UserData.shared.info.count > 0 {
            tableView.backgroundView?.isHidden = true
            userLoadingIndicator.stopAnimating()
        } else {
            tableView.backgroundView?.isHidden = false
        }
        return UserData.shared.info.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UserData.shared.info[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0: // 大頭照
 
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell, for: indexPath) as! UserImageCell
            
            if let userPortrait = self.userPortrait {
                cell.userPortraitImageView.image = UIImage(data: userPortrait)
            } else {
                cell.userPortraitImageView.image = UIImage(named: DEFAULT_USER_PORTRAIT)
            }
            if let userBackground = self.userBackground {
                cell.userBackgroundImageView.image = UIImage(data: userBackground)
            } else {
                cell.userBackgroundImageView.image = UIImage(named: DEFAULT_USER_BACKGROUND)
            }
            return cell
            
        case 1: // 名字

            let cell = tableView.dequeueReusableCell(withIdentifier: nameCell, for: indexPath) as! UserNameCell
            cell.userNameLabel.text = UserData.shared.info[indexPath.section][indexPath.row]
            return cell
            
        case 2: // 會員資訊
            
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell, for: indexPath) as! UserInfoCell
            cell.userInfoDetail.text = UserData.shared.info[indexPath.section][indexPath.row]
            cell.userInfoTitle.text = infoTitle[indexPath.row]
            return cell

        case 3: // 個人簡介
            
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCell, for: indexPath) as! UserProfileCell
            cell.userProfileLabel.text = UserData.shared.info[indexPath.section][indexPath.row]
            return cell

        case 4: // 專業技能
            
            guard userAccess == .coach else { fallthrough }
            let cell = tableView.dequeueReusableCell(withIdentifier: professionCell, for: indexPath) as! UserProfessionCell
            cell.userProfessionLabel.text = UserData.shared.info[indexPath.section][indexPath.row]
            return cell
        
        case 5: // 登出按鈕
            
            let cell = tableView.dequeueReusableCell(withIdentifier: sginOutCell, for: indexPath) as! UserSginOutCell
            return cell
            
        default:
            return UITableViewCell()
        }
    }
 
    
    
 // MARK: - Section Methods.
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let bkgdColor = UIColor(red: 0.922, green: 0.922, blue: 0.945, alpha: 1.0)
        let btnColor = UIColor(red: 0.271, green: 0.349, blue: 0.694, alpha: 1.0)
        let frame = tableView.frame
        // 基底
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        view.backgroundColor = bkgdColor
        // 標題
        let title = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 30))
        title.font = UIFont.systemFont(ofSize: 16)
        
        switch section {
            
        case 2: // 編輯會員資訊
            // Title
            title.text = "會員資訊"
            // Button
            let modifyBtn = UIButton(frame: CGRect(x: frame.size.width - 85, y: 2.5, width: 70, height: 25))
            modifyBtn.layer.cornerRadius = 5
            modifyBtn.backgroundColor = btnColor
            modifyBtn.setTitle("編輯", for: .normal)
            modifyBtn.setTitleColor(UIColor.white, for: .normal)
            modifyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            modifyBtn.addTarget(self, action: #selector(presentModifyView(_:)), for: .touchUpInside)
            // View
            view.addSubview(modifyBtn)
            view.addSubview(title)
            return view

        case 3: // 個人簡介
            // Title
            title.text = "個人簡介"
            view.addSubview(title)
            return view
            
        case 4: // 專業技能
            
            guard userAccess == .coach else { fallthrough }
            // Title
            title.text = "專業技能"
            // Button
            let ProBtn = UIButton(frame: CGRect(x: frame.size.width - 85, y: 2.5, width: 70, height: 25))
            ProBtn.layer.cornerRadius = 5
            ProBtn.backgroundColor = btnColor
            ProBtn.setTitle("編輯", for: .normal)
            ProBtn.setTitleColor(UIColor.white, for: .normal)
            ProBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            ProBtn.addTarget(self, action: #selector(presentProfessionView(_:)), for: .touchUpInside)
            // View
            view.addSubview(ProBtn)
            view.addSubview(title)
            return view
            
        default:
            return nil
        }
    }
    
    // Section Height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2,3:
            return 30
        case 4:
            guard userAccess == .coach else { fallthrough }
            return 30
        default:
            return 0
        }
    }
    
    // 轉跳會員編輯畫面
    @objc private func presentModifyView(_ sender: UIButton) {
        sender.pulse()
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "modifyVC")
        let rootViewController = self.view.window?.rootViewController
        rootViewController?.present(loginView, animated: true, completion: nil)
    }

    // 轉跳專業編輯畫面
    @objc private func presentProfessionView(_ sender: UIButton) {
        sender.pulse()
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "professionVC")
        let rootViewController = self.view.window?.rootViewController
        rootViewController?.present(loginView, animated: true, completion: nil)
    }
    
    

 // MARK: - 使用者頭像及背景
    
    @IBAction func modifyUserImage(_ sender: UITapGestureRecognizer) {
        
        selectUserImageType = .selectPortrait
        
        let alert = UIAlertController(title: "更換大頭照", message: nil, preferredStyle: .actionSheet)
        let takePicture = UIAlertAction(title: "使用相機", style: .default) { (action) in
            self.userImagePicker.sourceType = .camera
            self.present(self.userImagePicker, animated: true, completion: nil)
        }
        let pickFromAlbum = UIAlertAction(title: "從相簿選擇照片", style: .default) { (action) in
            self.userImagePicker.sourceType = .photoLibrary
            self.present(self.userImagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(takePicture)
        alert.addAction(pickFromAlbum)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func modifyUserGroundImage(_ sender: UITapGestureRecognizer) {
        
        selectUserImageType = .selectBackground

        let alert = UIAlertController(title: "更換背景照片", message: nil, preferredStyle: .actionSheet)
        let takePicture = UIAlertAction(title: "使用相機", style: .default) { (action) in
            self.userGroundPicker.sourceType = .camera
            self.present(self.userGroundPicker, animated: true, completion: nil)
        }
        let pickFromAlbum = UIAlertAction(title: "從相簿選擇照片", style: .default) { (action) in
            self.userGroundPicker.sourceType = .photoLibrary
            self.present(self.userGroundPicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(takePicture)
        alert.addAction(pickFromAlbum)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
 // MARK: - Connect DataBase Methods
    
    private func getUserInfo(account: String) {
        
        let request: [String: Any] = ["action": "findById", "account": account]
        Task.postRequestData(urlString: urlString + urlUserInfo , request: request) { (error, data) in
        
            guard error == nil, let data = data else { return }
            
            let decoder = JSONDecoder()
            let results = try? decoder.decode(User.self, from: data)
            
            guard let result = results else { return }
            
            if let userPortraitBase64 = result.userPortraitBase64 {
                self.userPortrait = Data(base64Encoded: userPortraitBase64)
            }
            
            if let userBackgroundBase64 = result.userBackgroundBase64 {
                self.userBackground = Data(base64Encoded: userBackgroundBase64)
            }
            
            var access = ""
            if result.userAccess == 1 {
                access = TEACHER_TEXT
            } else if result.userAccess == 2 {
                access = STUDENT_TEXT
            } else {
                access = NOT_EDIT_TEXT
            }
            
            var gender = ""
            if result.userGender == 1 {
                gender = MEN_TEXT
            } else if result.userGender == 2 {
                gender = WOMEN_TEXT
            } else {
                gender = NOT_EDIT_TEXT
            }
            
            var address = ""
            if let userAddress = result.userAddress, !userAddress.isEmpty {
                address = userAddress
            } else {
                address = NOT_EDIT_TEXT
            }
            
            var tel = ""
            if let userTel = result.userTel, !userTel.isEmpty {
                tel = userTel
            } else {
                tel = NOT_EDIT_TEXT
            }
            
            UserData.shared.info.removeAll() // 開始加入 User Info !!!
           
            UserData.shared.info.append(["Image"]) // Image Cell 預留
            if let userName = result.userName, !userName.isEmpty {
                UserData.shared.info.append([userName])
            } else {
                UserData.shared.info.append([NOT_EDIT_TEXT])
            }
        
            UserData.shared.info.append([access, gender, address, tel])
            
            if let userProfile = result.userProfile, !userProfile.isEmpty {
                UserData.shared.info.append([userProfile])
            } else {
                UserData.shared.info.append([NOT_EDIT_TEXT])
            }
        
            if result.userAccess == 1 {
                self.getUserProfession(account: account)
            } else {
                self.setSginOutButton()
            }
        }
    }

    private func getUserProfession(account: String) {

        let request: [String: Any] = ["action": "findProfessionById", "user_id": account]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            let decoder = JSONDecoder()
            let results = try? decoder.decode([Profession].self, from: data)
            guard let result = results else { return }
     
            if result.count == 0 {
                UserData.shared.info.append([NOT_EDIT_TEXT])
            } else {
                userProfessions = result
                var professions = [String]()
                for profession in result { professions.append(profession.professionName) }
                UserData.shared.info.append(professions)
            }
            self.setSginOutButton()
        }
    }
    
    private func setSginOutButton() {  // 加上登出按鈕
        UserData.shared.info.append(["SginOut"])
        tableView.reloadData()
    }
    
    private func updateUserInfoIamge(account: String, select: Bool, base64Image: String) {
        
        let request: [String: Any] = ["action" : "updataUserPhoto",
                                      "account" : account,
                                      "imageSelect" : select,
                                      "imageBase64" : base64Image]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            print("Q1")
            guard let result = String(data: data, encoding: .utf8) else {
                return
            }
            print("Q2")
            
            if result == "0" {
                print("GG")
            } else {
                print("OK")
            }
        }
    }
    
    private func checkSelectImageType(image: UIImage) {
        
        guard let account = userAccount, let base64Image = image.base64() else { return }
        
        let dataImage = UIImageJPEGRepresentation(image, 1.0)
        
        switch selectUserImageType {
            
        case .selectPortrait:
            userPortrait = dataImage
            updateUserInfoIamge(account: account, select: false, base64Image: base64Image)
            
        case .selectBackground:
            userBackground = dataImage
            updateUserInfoIamge(account: account, select: true, base64Image: base64Image)
            
        case .none:
            break
        }
        
        selectUserImageType = .none
        tableView.reloadData()
    }

 // MARK: - SginOut Methods.
    
    @IBAction func sginoutButton(_ sender: UIButton) {
        Alert.shared.buildDoubleAlert(viewController: self, alertTitle: SGIN_OUT_TEXT, alertMessage: nil, actionTitles: [CANCEL_TEXT, OK_TEXT], firstHandler: { (action) in
            return
        }) { (action) in
            self.prepareSginout()
            presentLoginView(view: self)
        }
    }
    
    func prepareSginout() {
        userAccess = .none
        userPortrait = nil
        userBackground = nil
        UserData.shared.info.removeAll()
        UserFile.shared.removeUserAccount()
        UserFile.shared.removeUserAccess()
    }
    
}


extension UserTableViewController: UIImageCropperProtocol {

    // MARK: - Did Finish Crop Image
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        
        guard let image = croppedImage else{ return }

        guard image.size.height * image.size.width > 900 * 1200 else {
            checkSelectImageType(image: image)
            return
        }
        
        // Start resize image
        let size = __CGSizeApplyAffineTransform((croppedImage?.size)!, CGAffineTransform(scaleX: 0.5, y: 0.5))
        let hasAlpha = false
        let scale : CGFloat = 0.0

        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))

        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else{
            assertionFailure("Scale Image Fail")
            return
        }
        UIGraphicsEndImageContext()
        checkSelectImageType(image: scaledImage)
    }
    
}

