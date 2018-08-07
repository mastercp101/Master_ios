//
//  SginUpViewController.swift
//  Master
//
//  Created by Diego on 2018/7/18.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class SginUpViewController: UIViewController {

    private let SGINUP_OK_ICON = "login_ok_icon"
    private let SGINUP_ERROR_ICON = "login_error_icon"
    private var checkAccountResult = false
    
    @IBOutlet weak var sginupCheckIconImageView: UIImageView!
    @IBOutlet weak var sginupAccountTextField: UITextField!
    @IBOutlet weak var sginupPasswordTextField: UITextField!
    @IBOutlet weak var sginupNameTextField: UITextField!
    @IBOutlet weak var sginupAccessSegmented: UISegmentedControl!
    
    private var signErrorTipsLock = true
    @IBOutlet weak var signErrorTipsLabel: UILabel!
    @IBOutlet weak var signErrorTipsStackView: UIStackView!
    
    @IBOutlet weak var signLoadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sginupAccountTextField.delegate = self
        sginupPasswordTextField.delegate = self
        sginupNameTextField.delegate = self
        // 提示訊息
        signErrorTipsStackView.alpha = 0
        // 轉轉
        signLoadingActivityIndicator.hidesWhenStopped = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func prepareSginup(_ sender: UIButton) {
        
        guard let account = sginupAccountTextField.text, !account.isEmpty else {
            showSignErrorTips(message: "尚有資料未填寫...")
            sender.shake()
            return
        }
        guard let password = sginupPasswordTextField.text, !password.isEmpty else {
            showSignErrorTips(message: "尚有資料未填寫...")
            sender.shake()
            return
        }
        guard let name = sginupNameTextField.text, !name.isEmpty else {
            showSignErrorTips(message: "尚有資料未填寫...")
            sender.shake()
            return
        }
        guard checkAccountResult else {
            showSignErrorTips(message: "帳號已有人使用")
            sender.shake()
            return
        }
        let access = sginupAccessSegmented.selectedSegmentIndex + 1 // 教練 = 1, 學員 ＝ 2
        
        Alert.shared.buildDoubleAlert(viewController: self, alertTitle: nil, alertMessage: "確定送出?", actionTitles: ["Cancel","OK"], firstHandler: { (action) in
            
            return
            
        }) { (action) in
            
            sender.setTitle("", for: .normal)
            self.signLoadingActivityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.sginupNow(account: account, password: password, name: name, access: access)
            }
            
        }
    }
    
    @IBAction func endEdit(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func sginupShowPassword(_ sender: UIButton) {
        sginupPasswordTextField.isSecureTextEntry = false
    }
    
    @IBAction func sginupHidePassword(_ sender: UIButton) {
        sginupPasswordTextField.isSecureTextEntry = true
    }
    
    @IBAction func checkAccountRepeat(_ sender: UITextField) {
        guard let account = sginupAccountTextField.text, !account.isEmpty else { return }
        connectionDBCheckAccount(account: account)
    }
    
    private func showSignErrorTips(message: String) {
        
        guard signErrorTipsLock else { return }
        signErrorTipsLock = false
        signErrorTipsLabel.text = message
        UIView.animate(withDuration: 0.15) { self.signErrorTipsStackView.alpha = 1 }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.15) { self.signErrorTipsStackView.alpha = 0 }
            self.signErrorTipsLock = true
        }
    }
    
    
    
 // MAEK: - Connect DB Methods.
    
    private func sginupNow(account: String, password: String, name: String, access: Int) {
        
        let request: [String: Any] = ["action": "signup",
                                      "account": account,
                                      "password": password,
                                      "name": name,
                                      "access": access]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }

            guard let result = String(data: data, encoding: .utf8) else {
                return
            }
            
            if result == "0" { // 理論上進不來
                self.signinButton.setTitle("註冊", for: .normal)
                self.signLoadingActivityIndicator.stopAnimating()
                Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "Error", handler: { (action) in })
            } else { // 註冊成功
                UserFile.shared.setUserAccount(account: account)
                UserFile.shared.setUserAccess(access: access)
                UserFile.shared.setUserName(name: name)
                self.dismiss(animated: true)
            }
        }
    }

    
    private func connectionDBCheckAccount(account: String) {
        
        let request: [String: Any] = ["action": "signupCheckAccount",
                                      "account": account]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let result = results , let checkResult = result as? Bool else { return }
            
            if checkResult {  // 帳號重複
                self.checkAccountResult = false
                self.sginupCheckIconImageView.isHidden = false
                self.sginupCheckIconImageView.image = UIImage(named: self.SGINUP_ERROR_ICON)
            } else {  // 帳號可以使用
                self.checkAccountResult = true
                self.sginupCheckIconImageView.isHidden = false
                self.sginupCheckIconImageView.image = UIImage(named: self.SGINUP_OK_ICON)
            }
        }
    }

}


extension SginUpViewController: UITextFieldDelegate {
    
    // 按下 Next 自動跳到下一個尚未填寫的輸入框
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var flag = false
        guard let text = textField.text, !text.isEmpty else { return flag }
        
        if let account = sginupAccountTextField.text, account.isEmpty  {
            sginupAccountTextField.becomeFirstResponder()
        } else if let password = sginupPasswordTextField.text, password.isEmpty {
            sginupPasswordTextField.becomeFirstResponder()
        } else if let name = sginupNameTextField.text, name.isEmpty {
            sginupNameTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            flag = true
        }
        return flag
    }
    
    // User 每輸入一個字就會執行
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        if string == " " { // 空白 Out !
            return false
        }
        return true
    }

}

