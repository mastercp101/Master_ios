//
//  LoginViewController.swift
//  Master
//
//  Created by Diego on 2018/7/17.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var enterAccountTextField: UITextField!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    @IBOutlet weak var loginBkgdImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Navigation 透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Text Field Placeholder Color
        loginBkgdImageView.image = UIImage(named: "login_test_bkgd")
        enterAccountTextField.attributedPlaceholder = NSAttributedString(string: "Enter Account ...", attributes: [.foregroundColor: UIColor.lightGray])
        enterPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Enter Password ...", attributes: [.foregroundColor: UIColor.lightGray])
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    @IBAction func prepareLogin(_ sender: UIButton) {
        
        // check test field ...
        guard let account = enterAccountTextField.text, let password = enterPasswordTextField.text ,!account.isEmpty, !password.isEmpty else {
            sender.shake()
            return
        }
        // check account and password (Srever) ...
        loginCheck(account: account, password: password)
        
        // save user default ...
        
        // dismiss view ...
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func goBackLastPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loginCheck(account: String, password: String) {
        
        let request: [String: Any] = ["action": "login", "account": account, "password": password]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
        
            guard error == nil, let data = data else { return }
           
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
           
            guard let result = results , let loginResult = result as? Bool else { return }
        
            if loginResult {
                // 登入成功
            } else {
                // 登入失敗
            }
        }
        // 以上異步執行 ...
    }
    
    
}
