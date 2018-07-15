//
//  singleCourseViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class singleCourseViewController: UIViewController {
    
    var dogName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
extension singleCourseViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? courseMainCell
            cell?.mainImageView.image = UIImage(named: dogName)
            cell?.applyBtn.setBorder()
            cell?.contectBtn.setBorder()
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? courseInfoCell
            cell?.courseDetailLabel.text = "123"
            return cell!
        }
    }
    

}
