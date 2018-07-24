//
//  User.swift
//  Master
//
//  Created by Diego on 2018/7/16.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import Foundation

// User Defaults Key
let USER_ACCOUNT_KEY = "userAccount"

let NOT_EDIT_TEXT = "尚未編輯"
let MEN_TEXT = "男"
let WOMEN_TEXT = "女"

// TODO: - 通用方法 ... ?
// 轉跳到登入畫面
func presentLoginView(view: UIViewController) {
    let storyboard = UIStoryboard(name: "Login", bundle: nil)
    let loginView = storyboard.instantiateViewController(withIdentifier: "loginVC")
    let rootViewController = view.view.window?.rootViewController
    rootViewController?.present(loginView, animated: true, completion: nil)
}

struct User:Codable {
    var userName: String?
    var userAddress: String?
    var userTel: String?
    var userPortraitBase64: String?
    var userBackgroundBase64: String?
    var userProfile: String?
    var userGender: Int?
    var userAccess: Int?
}


// MARK: - UserDefaults 系列
class UserAccount {
    
    static let shared = UserAccount()
    private init() {}
    private let userDefault = UserDefaults.standard
    
    func getUserAccount() -> String? { // Important!!! 子桓的從 UserDefaults 拿到使用者帳號方法
        guard let result = userDefault.string(forKey: USER_ACCOUNT_KEY), !result.isEmpty else {
            return nil
        }
        return result
    }
    
    func setUserAccount(account: String) {
        userDefault.set(account, forKey: USER_ACCOUNT_KEY)
        userAccount = account
    }
    
    func removeUserAccount() {
        userDefault.removeObject(forKey: USER_ACCOUNT_KEY)
        userAccount = nil
    }
}


// MARK: - 多頁面共享資料
class UserInfo {
    
    static let shared = UserInfo()
    private init() {}
    
    var info = [[String]]()
}
