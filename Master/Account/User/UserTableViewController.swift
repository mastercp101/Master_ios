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


class UserTableViewController: UITableViewController {

    // 假資料
    private var userInfo = [["圖片"],["名字"],["身份","性別","地址","電話"],["自我介紹"],["登出"]]
//    private var userInfo = [[String]]() // 正牌
    private let infoTitle = ["身份","性別","地址","電話"]
    private var userPortrait: Data?
    private var userBackground: Data?

    private let userAccount = "Cindy"
    private var userAccess = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.delaysContentTouches = false
//        getUserInfo() // 串接DB ...

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

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
        case 0:
            
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
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: nameCell, for: indexPath) as! UserNameCell
            cell.userNameLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell, for: indexPath) as! UserInfoCell
            cell.userInfoDetail.text = userInfo[indexPath.section][indexPath.row]
            cell.userInfoTitle.text = infoTitle[indexPath.row]
            return cell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCell, for: indexPath) as! UserProfileCell
            cell.userProfileLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell
            
        case 4: // 專業技能 ?
            
            if userAccess {
                let cell = tableView.dequeueReusableCell(withIdentifier: professionCell, for: indexPath) as! UserProfessionCell
                cell.userProfessionLabel.text = userInfo[indexPath.section][indexPath.row]
                return cell
            } else {
                fallthrough
            }
            
        case 5:
            
            tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: sginOutCell, for: indexPath) as! UserSginOutCell
            return cell
            
        default:
            
            return UITableViewCell()
        }
    }
 
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let title: String?
        
        switch section {
        case 2:
            title = "會員資訊"
        case 3:
            title = "個人簡介"
        case 4:
            if userAccess {
                title = "專業技能"
            } else {
                fallthrough
            }
        default:
            title = nil
        }
        return title
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
    }
    */

    
    func getUserInfo() {
        
        let request: [String: Any] = ["action": "findById", "account": userAccount]
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
            
            self.userInfo.removeAll()
            self.userInfo.append([""]) // Image Cell 預留
            
            if let userName = result.userName, !userName.isEmpty {
                self.userInfo.append([userName])
            } else {
                self.userInfo.append(["尚未設定名稱"])
            }
            
            self.userInfo.append([access, gender, address, tel])
            
            if let userProfile = result.userProfile, !userProfile.isEmpty {
                self.userInfo.append([userProfile])
            } else {
                self.userInfo.append(["尚未編輯個人簡介"])
            }
        
            if result.userAccess == 1 {
                self.getUserProfession()
            } else {
                self.setSginOutButton()
            }
        }
    }

    func getUserProfession() {
        
        let request: [String: Any] = ["action": "getUserProfession", "account": userAccount]
        
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
    
    func setSginOutButton() {
        // 加上登出按鈕
        self.userInfo.append([""])
        self.tableView.reloadData()
    }
    
    
    @IBAction func sginoutButton(_ sender: UIButton) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: USER_ACCOUNT_KEY)
        presentLoginView()
    }
    
    
    
    
    
    
    // PODO: - 通用方法 ...
    
    func presentLoginView() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "loginVC")
        present(loginView, animated:true, completion:nil)
        
    }

    
    @IBAction func unwindLogin_子桓的登入返回(_ segue : UIStoryboardSegue) {
        // nope ...
    }
    
    
    
}
