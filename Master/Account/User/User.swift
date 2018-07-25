//
//  User.swift
//  Master
//
//  Created by Diego on 2018/7/16.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import Foundation

// TODO: - 待整理到其他地方
// User Defaults Key
let USER_ACCOUNT_KEY = "userAccount"
let USER_ACCESS_KEY = "userAccess"
// UserScript
let NOT_EDIT_TEXT = "尚未編輯"
let MEN_TEXT = "男"
let WOMEN_TEXT = "女"
let TEACHER_TEXT = "教練"
let STUDENT_TEXT = "學員"
let OK_TEXT = "確定"
let CANCEL_TEXT = "取消"
// 轉跳到登入畫面
func presentLoginView(view: UIViewController) {
    let storyboard = UIStoryboard(name: "Login", bundle: nil)
    let loginView = storyboard.instantiateViewController(withIdentifier: "loginVC")
    let rootViewController = view.view.window?.rootViewController
    rootViewController?.present(loginView, animated: true, completion: nil)
}
// TODO: - 待整理到其他地方


enum UserAccess {
    case coach   // 教練
    case student // 學員
    case none   // 沒有登入
}

struct User: Codable {
    
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
class UserFile {
    
    static let shared = UserFile()
    private init() {}
    private let userDefault = UserDefaults.standard
    
    // 帳號
    func getUserAccount() -> String? { // Important!!! 子桓的從 UserDefaults 拿到使用者帳號方法
        guard let result = userDefault.string(forKey: USER_ACCOUNT_KEY), !result.isEmpty else {
            return nil
        }
        return result
    }
    func setUserAccount(account: String) {
        userAccount = account
        userDefault.set(account, forKey: USER_ACCOUNT_KEY)
        
    }
    func removeUserAccount() {
        userAccount = nil
        userDefault.removeObject(forKey: USER_ACCOUNT_KEY)
    }
    
    // 權限
    func getUserAccess() -> UserAccess {
        let result = userDefault.integer(forKey: USER_ACCESS_KEY)
        switch result {
        case 1:
            return .coach
        case 2:
            return .student
        default:
            return .none
        }
        
    }
    func setUserAccess(access: Int) {
        switch access {
        case 1:
            userAccess = .coach
        case 2:
            userAccess = .student
        default:
            userAccess = .none
        }
        userDefault.set(access, forKey: USER_ACCESS_KEY)
    }
    func removeUserAccess() {
        userAccess = .none
        userDefault.removeObject(forKey: USER_ACCESS_KEY)
    }
}

// MARK: - 多頁面共享資料
class UserData {
    
    static let shared = UserData()
    private init() {}
    
    var info = [[String]]()
}
