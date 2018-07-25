//
//  UserModifyViewController.swift
//  Master
//
//  Created by Diego on 2018/7/20.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

private let PROFILE_TEXT = "請輸入個人簡介..."
private let MODIFY_TEXT = "即將修改會員資料"

class UserModifyViewController: UIViewController {
    
    @IBOutlet weak var modifyScrollView: UIScrollView!
    @IBOutlet weak var modifyNameTextField: UITextField!
    @IBOutlet weak var modifyGenderSegmented: UISegmentedControl!
    @IBOutlet weak var modifyAddressTextField: UITextField!
    @IBOutlet weak var modifyTelTextField: UITextField!
    @IBOutlet weak var modifyProfileTextView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // 開始監聽鍵盤
        Common.shared.addObserves(scrollView: modifyScrollView)
        // TextField
        modifyNameTextField.delegate = self
        modifyAddressTextField.delegate = self
        modifyTelTextField.delegate = self
        // TextView
        modifyProfileTextView.delegate = self
        // 取消 ScrollView 延遲
        modifyScrollView.delaysContentTouches = false
        // TextView 外框
        modifyProfileTextView.layer.borderWidth = 1.0
        modifyProfileTextView.layer.borderColor = UIColor.lightGray.cgColor // 修改顏色 ?
        prepareModifyView()
    }

    deinit {
        // 移除監聽
        Common.shared.removeObservers(viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endEdit(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveModify(_ sender: UIButton) {
    
        guard let name = modifyNameTextField.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
            sender.shake()
            return
        }
        guard let address = modifyAddressTextField.text?.trimmingCharacters(in: .whitespaces), !address.isEmpty else {
            sender.shake()
            return
        }
        guard let tel = modifyTelTextField.text?.trimmingCharacters(in: .whitespaces), !tel.isEmpty else {
            sender.shake()
            return
        }
        guard let profile = modifyProfileTextView.text, !profile.trimmingCharacters(in: .whitespaces).isEmpty, profile != PROFILE_TEXT  else {
            sender.shake()
            return
        }
        var gender: Int
        switch modifyGenderSegmented.selectedSegmentIndex {
        case 0, 1:
            gender = modifyGenderSegmented.selectedSegmentIndex + 1
        default:
            sender.shake()
            return
        }
        self.view.endEditing(true)
        
        Alert.shared.buildDoubleAlert(viewController: self, alertTitle: MODIFY_TEXT, alertMessage: nil, actionTitles: [CANCEL_TEXT, OK_TEXT], firstHandler: { (action) in
            return
        }) { (action) in
            // 連接修改會員資料
            if let account = userAccount {
                self.updateUserInfo(account: account, name: name, gender: gender, address: address, tel: tel, profile: profile)
            }
        }
    }
    

    private func prepareModifyView() {
        
        modifyNameTextField.text = UserData.shared.info[1][0]
        
        let gender = UserData.shared.info[2][1]
        if gender != NOT_EDIT_TEXT {
            switch gender {
            case MEN_TEXT:
                modifyGenderSegmented.selectedSegmentIndex = 0
            case WOMEN_TEXT:
                modifyGenderSegmented.selectedSegmentIndex = 1
            default:
                break
            }
        }
        
        let address = UserData.shared.info[2][2]
        if address != NOT_EDIT_TEXT { modifyAddressTextField.text = address }
        
        let tel = UserData.shared.info[2][3]
        if tel != NOT_EDIT_TEXT { modifyTelTextField.text = tel }
        
        let profile = UserData.shared.info[3][0]
        if profile != NOT_EDIT_TEXT {
            modifyProfileTextView.text = profile
        } else {
            modifyProfileTextView.text = PROFILE_TEXT
        }
    }
    
    private func returnUserInfo(name: String, gender: Int, address: String, tel: String, profile: String) {
        
        let access = UserData.shared.info[2][0]
        var genderStr: String
        switch gender {
        case 1:
            genderStr = MEN_TEXT
        case 2:
            genderStr = WOMEN_TEXT
        default:
            genderStr = NOT_EDIT_TEXT
        }
        let userName = [name]
        let userData = [access, genderStr, address, tel]
        let userProfile = [profile]
        
        var userInfo = UserData.shared.info
        userInfo.remove(at: 1)
        userInfo.insert(userName, at: 1)
        userInfo.remove(at: 2)
        userInfo.insert(userData, at: 2)
        userInfo.remove(at: 3)
        userInfo.insert(userProfile, at: 3)
        // 覆蓋上新的資料
        UserData.shared.info = userInfo
    }
    
    
 // MAEK: - Connect DB Methods.
    
    private func updateUserInfo(account: String, name: String, gender: Int, address: String, tel: String, profile: String) {

        let request: [String: Any] = ["action" : "editMemberInfo",
                                      "account" : account,
                                      "name" : name,
                                      "gender" : gender,
                                      "address" : address,
                                      "tel" : tel,
                                      "profile" : profile]
        
        Task.postRequestData(urlString: urlString + urlUserInfo, request: request) { (error, data) in
            
            guard error == nil, let data = data else { return }
            
            guard let result = String(data: data, encoding: .utf8) else {
                return
            }
            if result == "0" { // 理論上進不來
                Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "Error", handler: { (action) in })
            } else {
                // 回傳 UserInfo ...
                self.returnUserInfo(name: name, gender: gender, address: address, tel: tel, profile: profile)
                self.dismiss(animated: true)
            }
        }
    }
}


extension UserModifyViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        // 如果開始編輯 ProfileTextView, ScrollView 會跳到最下面
        let leftBottomRect = CGRect(x: 0, y: self.view.frame.maxY - 1, width: 1, height: 1)
        modifyScrollView.scrollRectToVisible(leftBottomRect, animated: true)

        if textView.text == PROFILE_TEXT {
            textView.text.removeAll()
        }
    }
}

extension UserModifyViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 變換 TextField 焦點
        var flag = false
        guard let text = textField.text, !text.isEmpty else { return flag }

        if let name = modifyNameTextField.text, name.isEmpty {
            modifyNameTextField.becomeFirstResponder()
        } else if let address = modifyAddressTextField.text, address.isEmpty {
            modifyAddressTextField.becomeFirstResponder()
        } else if let tel = modifyTelTextField.text, tel.isEmpty {
            modifyTelTextField.becomeFirstResponder()
        } else if let profile = modifyProfileTextView.text, profile.trimmingCharacters(in: .whitespaces).isEmpty {
            modifyProfileTextView.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            flag = true
        }
        return flag
    }
    
}


