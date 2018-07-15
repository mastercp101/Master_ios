//
//  AccountSwitchViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

// Switch ViewController Only!
// Don't write any code in here
class AccountSwitchViewController: UIViewController {
    
    
    @IBOutlet weak var switchView: UIView!
    let userVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "userVC")
    let photoVC = UIStoryboard(name: "Photo", bundle: nil).instantiateViewController(withIdentifier: "photoVC")
    let courseVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "courseVC")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchView.addSubview(userVC.view)
    }
    
    @IBAction func swichViewSegmentedTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            switchView.addSubview(userVC.view)
        case 1:
            switchView.addSubview(photoVC.view)
        case 2:
            switchView.addSubview(courseVC.view)
        default:
            switchView.addSubview(courseVC.view)
        }
    }
    
}
