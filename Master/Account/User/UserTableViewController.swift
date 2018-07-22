//
//  UserTableViewController.swift
//  Master
//
//  Created by Diego on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

private let DEFAULT_USER_PORTRAIT = "user_default_por"
private let DEFAULT_USER_BACKGROUND = "user_default_bkgd"

private let imageCell = "UserImageCell"
private let nameCell = "UserNameCell"
private let infoCell = "UserInfoCell"
private let profileCell = "UserProfileCell"
private let professionCell = "UserProfessionCell"
private let sginOutCell = "UserSginOutCell"

private let titleCell = "TitleCell"
private let infoTitleCell = "InfoTitleCell"
private let proTitleCell = "ProTitleCell"

class UserTableViewController: UITableViewController {

    private var userInfo = [[String]]()
    private let infoTitle = ["身份","性別","地址","電話"]
    private var userPortrait: Data?
    private var userBackground: Data?
    private var userAccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delaysContentTouches = false
       
        #if DEBUG
        userAccess = true
        userInfo = [["圖片"],["名字"],["會員資訊"],["身份","性別","地址","電話"],["個人簡介"],["自我介紹"],["專業技能"],["技能","技能2","技能3"],["登出"]]
        #else
        if let account = userAccount {
            // TODO: - 網路檢查?
            getUserInfo(account: account)
        } else {
            userInfo = [["圖片"],["名字"],["身份","性別","地址","電話"],["自我介紹"],["登出"]]
        }
        #endif
    }

     // TODO: - 回到此頁面重新整理表格?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return userInfo.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userInfo[section].count
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
            cell.userNameLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell
            
        case 2: // 會員資訊 Title
            
            let cell = tableView.dequeueReusableCell(withIdentifier: infoTitleCell, for: indexPath) as! UserInfoTitleCell
            cell.userInfoTitleLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell
            
        case 3: // 會員資訊
            
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell, for: indexPath) as! UserInfoCell
            cell.userInfoDetail.text = userInfo[indexPath.section][indexPath.row]
            cell.userInfoTitle.text = infoTitle[indexPath.row]
            return cell
            
        case 4: // 個人簡介 Title
            
            let cell = tableView.dequeueReusableCell(withIdentifier: titleCell, for: indexPath) as! UserTitleCell
            cell.userTitleLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell
            
        case 5: // 個人簡介
            
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCell, for: indexPath) as! UserProfileCell
            cell.userProfileLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell
            
        case 6: // 專業技能 Title
            
            guard userAccess else { fallthrough }
            let cell = tableView.dequeueReusableCell(withIdentifier: proTitleCell, for: indexPath) as! UserProTitleCell
            cell.userProTitleLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell
            
        case 7: // 專業技能
            
            guard userAccess else { fallthrough }
            let cell = tableView.dequeueReusableCell(withIdentifier: professionCell, for: indexPath) as! UserProfessionCell
            cell.userProfessionLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell
        
        case 8: // 登出按鈕
            
            tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: sginOutCell, for: indexPath) as! UserSginOutCell
            return cell
            
        default:

            return UITableViewCell()
        }
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

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? UserModifyViewController {
            controller.test = userInfo
        }
    }

    
    
    
    
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
                access = "教練"
                self.userAccess = true
            } else if result.userAccess == 2 {
                access = "學員"
                self.userAccess = false
            } else {
                access = "尚未設定身份"
                self.userAccess = false
            }
            
            var gender = ""
            if result.userGender == 1 {
                gender = "男"
            } else if result.userGender == 2 {
                gender = "女"
            } else {
                gender = "尚未設定性別"
            }
            
            var address = ""
            if let userAddress = result.userAddress, !userAddress.isEmpty {
                address = userAddress
            } else {
                address = "尚未設定地址"
            }
            
            var tel = ""
            if let userTel = result.userTel, !userTel.isEmpty {
                tel = userTel
            } else {
                tel = "尚未設定聯絡方式"
            }
            
            // 開始加入 User Info !!!
            
            self.userInfo.removeAll()
            
            self.userInfo.append(["頭像"]) // Image Cell 預留
            if let userName = result.userName, !userName.isEmpty {
                self.userInfo.append([userName])
            } else {
                self.userInfo.append(["尚未設定名稱"])
            }
            
            self.userInfo.append(["會員資訊"])
            self.userInfo.append([access, gender, address, tel])
            self.userInfo.append(["個人簡介"])
            if let userProfile = result.userProfile, !userProfile.isEmpty {
                self.userInfo.append([userProfile])
            } else {
                self.userInfo.append(["尚未編輯個人簡介"])
            }
        
            if result.userAccess == 1 {
                self.userInfo.append(["專業技能"])
                self.getUserProfession(account: account)
            } else {
                self.setSginOutButton()
            }
        }
    }

    func getUserProfession(account: String) {
   
        let request: [String: Any] = ["action": "getUserProfession", "account": account]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let results =  try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            guard let result = results , let profession = result as? [String] else { return }
        
            if profession.count == 0 {
                self.userInfo.append(["尚未編輯專業技能"])
            } else {
                self.userInfo.append(profession)
            }
            self.setSginOutButton()
        }
    }
    
    func setSginOutButton() {  // 加上登出按鈕
        self.userInfo.append(["登出"])
        self.tableView.reloadData()
    }
    
    @IBAction func sginoutButton(_ sender: UIButton) {
        Alert.shared.buildDoubleAlert(viewController: self, alertTitle: "您即將登出", alertMessage: nil, actionTitles: ["取消","確定"], firstHandler: { (action) in
            // nope
        }) { (action) in
            UserAccount.shared.removeUserAccount()
            presentLoginView(view: self)
        }
    }
    
    
//    @IBAction func unwindLogin_子桓的登入返回(_ segue : UIStoryboardSegue) {
//        // nope ...
//    }
    
    
    
}
