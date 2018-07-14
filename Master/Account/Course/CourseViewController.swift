//
//  CourseViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import iCarousel

class CourseViewController: UIViewController {

    @IBOutlet weak var iCarouselView: iCarousel!
    var dogName = ["beagle","bulldog","bordercollie","shiba"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setICarousel()
        downloadCourse()
    }
    
    private func downloadCourse(){
        
    }
    
    private func setICarousel(){
        iCarouselView.type = .rotary
        iCarouselView.contentMode = .scaleAspectFit
        iCarouselView.isPagingEnabled = true
        iCarouselView.isVertical = true
    }
    
    
}
extension CourseViewController : iCarouselDelegate,iCarouselDataSource{
    func numberOfItems(in carousel: iCarousel) -> Int {
        return dogName.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var courseItemView : CourseItemView
        let dog = dogName[index]
        
        if view == nil{
            let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
            courseItemView = CourseItemView(frame: frame)
            courseItemView.courseImageView.contentMode = .scaleAspectFit
        }else{
            courseItemView = view as! CourseItemView
        }
        
        courseItemView.courseImageView.image = UIImage(named: dog)
        courseItemView.courseNameLabel.text = dog
        
        return courseItemView
    }
}
