//
//  OtherUserInfoTableViewController.swift
//  Master
//
//  Created by Diego on 2018/8/7.
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


class OtherUserInfoTableViewController: UITableViewController {

    // 傳遞過來的資料 ...
    var otherUserId: String?
    var otherUserInfo: User?
    // table view 資料
    var otherUserInfos = [[String]]()
    private let otherInfoTitle = ["身份","性別","地址","電話"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        perpaerTableViewData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return otherUserInfos.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return otherUserInfos[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        [["image"],["名字"],["身份","性別","地址","電話"],["自我介紹"],["技能","技能2","技能3"]]
        switch indexPath.section {
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: imageCell, for: indexPath) as? UserImageCell else {
                return UITableViewCell()
            }
            if let profileBase64 = otherUserInfo?.userPortraitBase64, let profile = Data(base64Encoded: profileBase64) {
                cell.userPortraitImageView.image = UIImage(data: profile)
            } else {
                cell.userPortraitImageView.image = UIImage(named: "user_default_por")
            }
            if let bkgdBase64 = otherUserInfo?.userBackgroundBase64, let bkgd = Data(base64Encoded: bkgdBase64) {
                cell.userBackgroundImageView.image = UIImage(data: bkgd)
            } else {
                cell.userBackgroundImageView.image = UIImage(named: "user_default_bkgd")
            }
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: nameCell, for: indexPath) as? UserNameCell else {
                return UITableViewCell()
            }
            cell.userNameLabel.text = otherUserInfos[indexPath.section][indexPath.row]
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: infoCell, for: indexPath) as? UserInfoCell else {
                return UITableViewCell()
            }
            cell.userInfoDetail.text = otherUserInfos[indexPath.section][indexPath.row]
            cell.userInfoTitle.text = otherInfoTitle[indexPath.row]
            return cell

        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: profileCell, for: indexPath) as? UserProfileCell else {
                return UITableViewCell()
            }
            cell.userProfileLabel.text = otherUserInfos[indexPath.section][indexPath.row]
            return cell
            
        case 4: // 專業技能

            let cell = tableView.dequeueReusableCell(withIdentifier: professionCell, for: indexPath) as! UserProfessionCell
            cell.userProfessionLabel.text = otherUserInfos[indexPath.section][indexPath.row]
            return cell
            
        default:
            return UITableViewCell()
        }
    
    }
 
    override  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 2:
            return "會員資訊"
        case 3:
            return "個人簡介"
        case 4:
            return "專業技能"
        default:
            return nil
        }
    }
    
    

    private func perpaerTableViewData() {
        
        guard let info = otherUserInfo else { return }
    
        var access = ""
        if info.userAccess == 1 {
            access = TEACHER_TEXT
        } else if info.userAccess == 2 {
            access = STUDENT_TEXT
        } else {
            access = NOT_EDIT_TEXT
        }
        
        var gender = ""
        if info.userGender == 1 {
            gender = MEN_TEXT
        } else if info.userGender == 2 {
            gender = WOMEN_TEXT
        } else {
            gender = NOT_EDIT_TEXT
        }
        
        var address = NOT_EDIT_TEXT
        if let userAddress = info.userAddress, !userAddress.isEmpty {
            address = userAddress
        }
        
        var tel = NOT_EDIT_TEXT
        if let userTel = info.userTel, !userTel.isEmpty {
            tel = userTel
        }
        
        otherUserInfos.append(["image"])
        otherUserInfos.append([info.userName ?? NOT_EDIT_TEXT])
        otherUserInfos.append([access, gender, address, tel])
        otherUserInfos.append([info.userProfile ?? NOT_EDIT_TEXT])
        
        // 如果是教練, 去取得他的專業
        if info.userAccess == 1, let account = otherUserId {
            getUserProfession(account: account)
        }
    }
    
    
 // MARK: - Connect DataBase Methods
    
    private func getUserProfession(account: String) {
        
        let request: [String: Any] = ["action": "findProfessionById", "user_id": account]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            let decoder = JSONDecoder()
            let results = try? decoder.decode([Profession].self, from: data)
            guard let result = results else { return }
            
            if result.count == 0 {
                self.otherUserInfos.append([NOT_EDIT_TEXT])
            } else {
                userProfessions = result
                var professions = [String]()
                for profession in result { professions.append(profession.professionName) }
                self.otherUserInfos.append(professions)
            }
            // 重新整理 ...
            self.tableView.reloadData()
        }
    }
    
}
