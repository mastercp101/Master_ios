//
//  UserScript.swift
//  Master
//
//  Created by Diego on 2018/7/25.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import Foundation

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


