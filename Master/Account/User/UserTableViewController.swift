//
//  UserTableViewController.swift
//  Master
//
//  Created by Diego on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

let NOT_EDIT_TEXT = "尚未編輯"
let MEN_TEXT = "男"
let WOMEN_TEXT = "女"

private let DEFAULT_USER_PORTRAIT = "user_default_por"
private let DEFAULT_USER_BACKGROUND = "user_default_bkgd"

private let imageCell = "UserImageCell"
private let nameCell = "UserNameCell"
private let infoCell = "UserInfoCell"
private let profileCell = "UserProfileCell"
private let professionCell = "UserProfessionCell"
private let sginOutCell = "UserSginOutCell"

class UserTableViewController: UITableViewController {

    private var userInfo = [[String]]()
    private let infoTitle = ["身份","性別","地址","電話"]
    private var userPortrait: Data?
    private var userBackground: Data?
    private var userAccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delaysContentTouches = false
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
        guard userInfo.count != 0 else {

            // TODO: - DeBug
            userAccess = true
            userInfo = [["image"],["名字"],["身份","性別","地址","電話"],["自介"],["技能","技能2","技能3"],["SginOut"]]
            UserInfo.shared.info = userInfo
            
            // TODO: - 網路檢查?
            if let account = userAccount {
                getUserInfo(account: account)
            } else {
                userInfo = [["image"],["名字"],["身份","性別","地址","電話"],["自介"],["SginOut"]]
            }
            return
        }
        
        // 否則會去 UserInfo 同步一次資料, 並重新整理
        userInfo = UserInfo.shared.info
        self.tableView.reloadData()
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
            
        case 2: // 會員資訊
            
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell, for: indexPath) as! UserInfoCell
            cell.userInfoDetail.text = userInfo[indexPath.section][indexPath.row]
            cell.userInfoTitle.text = infoTitle[indexPath.row]
            return cell

        case 3: // 個人簡介
            
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCell, for: indexPath) as! UserProfileCell
            cell.userProfileLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell

        case 4: // 專業技能
            
            guard userAccess else { fallthrough }
            let cell = tableView.dequeueReusableCell(withIdentifier: professionCell, for: indexPath) as! UserProfessionCell
            cell.userProfessionLabel.text = userInfo[indexPath.section][indexPath.row]
            return cell
        
        case 5: // 登出按鈕
            
            tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: sginOutCell, for: indexPath) as! UserSginOutCell
            return cell
            
        default:

            return UITableViewCell()
        }
    }
 
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

       
        let frame: CGRect = tableView.frame

        switch section {
            
        case 2: // 會員資訊
             let view: UIView?
            let DoneBut = UIButton(frame: CGRect(x: frame.size.width - 200, y: 0, width: 150, height: 30))
            DoneBut.setTitle("Done", for: .normal)
            DoneBut.backgroundColor = UIColor.blue
             DoneBut.addTarget(self, action: #selector(presentModifyView(_:)), for: .touchUpInside)
            let title = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height: 30))
            title.text = "會員資訊"

            view = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            view?.backgroundColor = UIColor.lightGray
            view?.addSubview(DoneBut)
            view?.addSubview(title)
            return view

        case 3: // 個人簡介
             let view: UIView?
            let title = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height: 35))
            title.text = "個人簡介"
            view = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            view?.backgroundColor = UIColor.lightGray
            view?.addSubview(title)
            return view
            
        case 4: // 專業技能
            guard userAccess else { fallthrough }
            let view: UIView?
            let DoneBut = UIButton(frame: CGRect(x: frame.size.width - 200, y: 0, width: 150, height: 30))
            DoneBut.setTitle("Done", for: .normal)
            DoneBut.backgroundColor = UIColor.blue
            DoneBut.addTarget(self, action: #selector(presentProfessionView(_:)), for: .touchUpInside)
            let title = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height: 30))
            title.text = "專業技能"

            view = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            view?.backgroundColor = UIColor.lightGray
            view?.addSubview(DoneBut)
            view?.addSubview(title)
            return view
        default:
            return nil
        }

      
    }
    
    // 轉跳會員編輯畫面
    @objc private func presentModifyView(_ sender: UIButton) {
        
        // TODO: - 改寫成單例模式
        
        sender.pulse()
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "modifyVC")
        let rootViewController = self.view.window?.rootViewController
        rootViewController?.present(loginView, animated: true, completion: nil)
    }

    // 轉跳專業編輯畫面
    @objc private func presentProfessionView(_ sender: UIButton) {
        sender.pulse()
       
        print("View")
        // TODO: - 轉跳專業編編輯畫面
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2,3:
            return 30
        case 4:
            guard userAccess else { fallthrough }
            return 30
        default:
            return 0
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
                access = "教練"
                self.userAccess = true
            } else if result.userAccess == 2 {
                access = "學員"
                self.userAccess = false
            } else {
                access = NOT_EDIT_TEXT
                self.userAccess = false
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
            
            self.userInfo.removeAll() // 開始加入 User Info !!!
           
            self.userInfo.append(["頭像"]) // Image Cell 預留
            if let userName = result.userName, !userName.isEmpty {
                self.userInfo.append([userName])
            } else {
                self.userInfo.append([NOT_EDIT_TEXT])
            }
        
            self.userInfo.append([access, gender, address, tel])
            
            if let userProfile = result.userProfile, !userProfile.isEmpty {
                self.userInfo.append([userProfile])
            } else {
                self.userInfo.append([NOT_EDIT_TEXT])
            }
        
            if result.userAccess == 1 {
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
                self.userInfo.append([NOT_EDIT_TEXT])
            } else {
                self.userInfo.append(profession)
            }
            self.setSginOutButton()
        }
    }
    
    func setSginOutButton() {  // 加上登出按鈕
        self.userInfo.append(["登出"])
        self.tableView.reloadData()
        UserInfo.shared.info = userInfo
    }
    
    

 // MARK: - SginOut Methods.
    
    @IBAction func sginoutButton(_ sender: UIButton) {
        Alert.shared.buildDoubleAlert(viewController: self, alertTitle: "您即將登出", alertMessage: nil, actionTitles: ["取消","確定"], firstHandler: { (action) in
            // nope
        }) { (action) in
            self.prepareSginout()
            presentLoginView(view: self)
        }
    }
    
    func prepareSginout() {
        userAccess = false
        userPortrait = nil
        userBackground = nil
        userInfo.removeAll()
        UserInfo.shared.info.removeAll()
        UserAccount.shared.removeUserAccount()
    }
    
    
}
