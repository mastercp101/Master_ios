//
//  OtherUserDetailViewController.swift
//  Master
//
//  Created by Diego on 2018/8/6.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class OtherUserDetailViewController: UIViewController {

    var testStr: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        print(testStr)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func goBack(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
