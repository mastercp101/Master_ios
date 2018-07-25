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

    private let infoTitle = ["身份","性別","地址","電話"]
    private var userPortrait: Data?
    private var userBackground: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delaysContentTouches = false
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
//            if let account = userAccount {
//                getUserInfo(account: account)
//            } else {
//                UserData.shared.info = [["image"],["尚未登入"],["尚未登入","尚未登入","尚未登入","尚未登入"],["尚未登入"],["out"]]
//            }
            return
        }
        // 否則會去 UserInfo 同步一次資料, 並重新整理
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
 // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return UserData.shared.info.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserData.shared.info[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0: // 大頭照
            
            print("大頭照")
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
            
            tableView.separatorStyle = .none
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
       
        print("還沒還沒還沒還沒還沒還沒還沒還沒還沒還沒還沒還沒還沒還沒還沒")
        
    }
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? UserModifyViewController {
            controller.test = userInfo
        }
    }
    */
    
    
    @IBAction func modifyUserImage(_ sender: UITapGestureRecognizer) {
        
        // TODO: - Camera and photo
        print("沒有沒有沒有沒有沒有沒有沒有沒有沒有沒有沒有沒有沒有沒有沒有沒有")
    }
    
    
 // MARK: - Connect DataBase Methods
    
    func getUserInfo(account: String) {
        
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

    func getUserProfession(account: String) {

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
    
    
    func setSginOutButton() {  // 加上登出按鈕
        UserData.shared.info.append(["SginOut"])
        self.tableView.reloadData()
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
