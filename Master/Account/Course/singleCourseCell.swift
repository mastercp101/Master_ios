//
//  singleCourseCell.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class courseMainCell : UITableViewCell{
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDateLabel: UILabel!
    @IBOutlet weak var coursePriceLabel: UILabel!
    @IBOutlet weak var contectBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
}

class courseInfoCell : UITableViewCell{
    @IBOutlet weak var courseDetailLabel: UILabel!
}

extension UIButton{
    func setBorder(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = self.bounds.height / 2
    }
}
