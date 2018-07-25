//
//  LoginViewController.swift
//  Master
//
//  Created by Diego on 2018/7/17.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let ACCOUNT_PLACEHOLDER = "Enter Account ..."
    private let PASSWORD_PLACEHOLDER = "Enter Password ..."
    private let LOGIN_VIEW_BACKGROUND = "login_test_bkgd"
    
    private var keyboardLock = true
    private var keyboardHeight: CGFloat?
    
    @IBOutlet weak var enterAccountTextField: UITextField!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    @IBOutlet weak var loginBkgdImageView: UIImageView!
    @IBOutlet weak var errorTipsLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLoginView()
        enterAccountTextField.delegate = self
        enterPasswordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(moveViewUp(_:)), name: .UIKeyboardWillShow, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.view.endEditing(true)
        resetType()
    }
    
    @objc func moveViewUp(_ aNotification: Notification) {
        
        guard keyboardLock else { return }
        keyboardLock = false
        let info = aNotification.userInfo
        let sizeValue = info![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let size = sizeValue.cgRectValue.size
        let height = size.height - 150
        UIView.animate(withDuration: 0.23) { self.view.frame.origin.y -= height }
        keyboardHeight = height
    }
    
    private func prepareLoginView() {
        // Text Field Placeholder Color
        loginBkgdImageView.image = UIImage(named: LOGIN_VIEW_BACKGROUND)
        enterAccountTextField.attributedPlaceholder = NSAttributedString(string: ACCOUNT_PLACEHOLDER, attributes: [.foregroundColor: UIColor.lightGray])
        enterPasswordTextField.attributedPlaceholder = NSAttributedString(string: PASSWORD_PLACEHOLDER, attributes: [.foregroundColor: UIColor.lightGray])
    }
    
    private func resetType() {
        keyboardLock = true
        keyboardHeight = nil
    }
    
    @IBAction func prepareLogin(_ sender: UIButton) {
        // check test field ...
        guard let account = enterAccountTextField.text, let password = enterPasswordTextField.text ,!account.isEmpty, !password.isEmpty else {
            sender.shake()
            return
        }
        // check account and password (Srever) ...
        loginCheck(account: account, password: password)
    }
    
    @IBAction func loginShowPassword(_ sender: UIButton) {
        enterPasswordTextField.isSecureTextEntry = false
    }
    
    @IBAction func loginHidePassword(_ sender: UIButton) {
        enterPasswordTextField.isSecureTextEntry = true
    }
    
    @IBAction func goBackLastPage(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
 // MAEK: - Connect DB Methods.
    
    private func loginCheck(account: String, password: String) {
        
        let request: [String: Any] = ["action": "login",
                                      "account": account,
                                      "password": password]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
        
            guard error == nil, let data = data else { return }
           
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
           
            guard let result = results , let loginResult = result as? Bool else { return }
        
            if loginResult { // 登入成功
                UserFile.shared.setUserAccount(account: account)
                self.getUserAccess(account: account)
            } else { // 登入失敗
                UIView.animate(withDuration: 0.2) { self.errorTipsLabel.alpha = 1 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                     UIView.animate(withDuration: 0.2) { self.errorTipsLabel.alpha = 0 }
                }
                self.loginButton.shake()
            }
        }
    }
    
    private func getUserAccess(account: String) {
        
        let request: [String: Any] = ["action": "getUserAccess", "account": account]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results, let access = result as? Int else {
                return
            }
            UserFile.shared.setUserAccess(access: access)
            self.dismiss(animated: true)
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    // 按下 Next 自動跳到下一個尚未填寫的輸入框
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var flag = false
        guard let text = textField.text, !text.isEmpty else { return flag }

        if let account = enterAccountTextField.text, account.isEmpty  {
            enterAccountTextField.becomeFirstResponder()
        } else if let password = enterPasswordTextField.text, password.isEmpty {
            enterPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if let keyboardHeight = keyboardHeight {
                UIView.animate(withDuration: 0.23) { self.view.frame.origin.y += keyboardHeight }
            }
            resetType()
            flag = true
        }
        return flag
    }
    
    // User 每輸入一個字就會執行
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 禁止User輸入空白
        if string == " " {
            return false
        }
        return true
    }

}





