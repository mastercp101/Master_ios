//
//  LoginRemindViewController.swift
//  Master
//
//  Created by Diego on 2018/7/20.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class LoginRemindViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showLogin(_ sender: UITapGestureRecognizer) {
        presentLoginView(view: self)
        // 跳到登入畫面 ...
        
        // TODO: - 網路判斷 ?
        
        // TODO: - 自動跳頁?
    }
    
    

}
