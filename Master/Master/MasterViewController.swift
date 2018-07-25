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
        // Important !
        userAccount = UserFile.shared.getUserAccount() // 帳號
        userAccess = UserFile.shared.getUserAccess() // 權限
    }
    
}

