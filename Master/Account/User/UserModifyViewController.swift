//
//  UserModifyViewController.swift
//  Master
//
//  Created by Diego on 2018/7/20.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

private let PROFILE_TEXT = "請輸入個人簡介..."


class UserModifyViewController: UIViewController {
    
    @IBOutlet weak var modifyScrollView: UIScrollView!
    @IBOutlet weak var modifyNameTextField: UITextField!
    @IBOutlet weak var modifyGenderSegmented: UISegmentedControl!
    @IBOutlet weak var modifyAddressTextField: UITextField!
    @IBOutlet weak var modifyTelTextField: UITextField!
    @IBOutlet weak var modifyProfileTextView: UITextView!
    
    
    
    // TODO: - 實作鍵盤升起 畫面移高方法, 移動 TextField 焦點
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveModify(_ sender: UIButton) {
        
        guard let name = modifyNameTextField.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
            // No name
            return
        }

        guard let address = modifyAddressTextField.text?.trimmingCharacters(in: .whitespaces), !address.isEmpty else {
            //
            return
        }

        guard let tel = modifyTelTextField.text?.trimmingCharacters(in: .whitespaces), !tel.isEmpty else {
            //
            return
        }

        guard let profile = modifyProfileTextView.text, !profile.isEmpty, profile != PROFILE_TEXT  else {
            //
            return
        }

        var gender: Int
        switch modifyGenderSegmented.selectedSegmentIndex {
        case 0, 1:
            gender = modifyGenderSegmented.selectedSegmentIndex + 1
        default:
            return
        }
        
        
        // TODO: - 再次詢問視窗
        
        
        if let account = userAccount {
            updateUserInfo(account: account, name: name, gender: gender, address: address, tel: tel, profile: profile)
        }
        
    }
    

    func prepareModifyView() {
        
        modifyNameTextField.text = UserInfo.shared.info[1][0]
        
        let gender = UserInfo.shared.info[2][1]
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
        
        let address = UserInfo.shared.info[2][2]
        if address != NOT_EDIT_TEXT {
            modifyAddressTextField.text = address
        }

        let tel = UserInfo.shared.info[2][3]
        if tel != NOT_EDIT_TEXT {
            modifyTelTextField.text = tel
        }
        
        let profile = UserInfo.shared.info[3][0]
        if profile != NOT_EDIT_TEXT {
            modifyProfileTextView.text = profile
        } else {
            modifyProfileTextView.text = PROFILE_TEXT
        }

    }
    
    func updateUserInfo(account: String, name: String, gender: Int, address: String, tel: String, profile: String) {

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
            
            
            // TODO: - 判斷結果
            
            
            if result == "0" { // 理論上進不來
                let alert = UIAlertController(title: "Error", message: "伺服器出錯，請聯絡管理員。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Know", style: .default))
                self.present(alert, animated: true)
            } else { // 註冊成功
                
                
                // TODO: - 將結果丟回 UserInfo
                
                
                print("成功啦!!")
                self.dismiss(animated: true)
            }
        }
    }
  
}


extension UserModifyViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PROFILE_TEXT {
            textView.text.removeAll()
        }
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//
//        let maxSize:CGFloat = 150
//
//        let tset = textView.frame
//        let test2 = CGSize(width: tset.size.width, height: CGFloat(MAXFLOAT))
//        var test3: CGSize = textView.sizeThatFits(test2)
//
//
//        if test3.height > tset.size.height {
//
//            if test3.height > maxSize {
//
//                test3.height = maxSize
//                textView.isScrollEnabled = false
//            } else {
//                textView.isScrollEnabled = true
//            }
//        }
//
//        textView.frame = CGRect(x: tset.origin.x , y: tset.origin.y, width: tset.size.width, height: test3.height)
//    }
//    
}

extension UserModifyViewController: UITextFieldDelegate {
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // 禁止User輸入空白
//        if string == " " {
//            return false
//        }
//        return true
//    }
    
}


