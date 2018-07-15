//
//  CourseItemView.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/14.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class CourseItemView: UIView {
    
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDateLabel: UILabel!
    @IBOutlet weak var courseStatusLabel: UILabel!
    

    override init(frame : CGRect) {
        super.init(frame : frame)
        Bundle.main.loadNibNamed("CourseItemView", owner: self, options: nil)
        containerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.75, height: self.bounds.height * 0.95)
        
        containerView.center.x = self.center.x
        containerView.center.y = self.center.y
        containerView.layer.cornerRadius = 15.0
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowOffset = CGSize.zero
        addSubview(containerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}














