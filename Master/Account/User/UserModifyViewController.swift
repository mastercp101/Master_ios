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
    
    deinit {
        print("ModifyView Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        modifyProfileTextView.delegate = self
        modifyScrollView.delaysContentTouches = false
        
        modifyProfileTextView.layer.borderWidth = 1.0
        modifyProfileTextView.layer.borderColor = UIColor.lightGray.cgColor

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
        
        // ...
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



