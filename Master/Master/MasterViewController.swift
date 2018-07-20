//
//  ViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        userAccount = getUserAccount() // Important!!!
    }

    // TODO: - 暫時放在這
    private func getUserAccount() -> String? { // Important!!! 子桓的從 UserDefaults 拿到使用者帳號方法
        let userDefault = UserDefaults.standard
        guard let result = userDefault.string(forKey: USER_ACCOUNT_KEY), !result.isEmpty else {
            return nil
        }
        return result
    }
    
}

