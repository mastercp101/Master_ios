//
//  Common.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

//Only put "let" property over here
//if you want to put variable property put it in singleton

// Connect DB URL
let urlString = "http://127.0.0.1:8080/Master/"


// Singleton
class Common{
    static let shared = Common()
    private init() {}
    
    // Double Action Alert
    typealias alertHandler = (UIAlertAction) -> ()
    func buildAlert(viewController : UIViewController,alertTitle : String,alertMessage : String?,firstActionTitle : String ,secondActionTitle : String,firstHandler : @escaping alertHandler,secondHandler : @escaping alertHandler){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let firstAlertAction = UIAlertAction(title: firstActionTitle, style: .default, handler: firstHandler)
        let secondAlertAction = UIAlertAction(title: secondActionTitle, style: .default, handler: secondHandler)
        alertController.addAction(firstAlertAction)
        alertController.addAction(secondAlertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

