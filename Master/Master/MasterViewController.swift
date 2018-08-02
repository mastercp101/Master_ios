//
//  ViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/9.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    private let waterSegue = "waterSegue"
    private let xsportSegue = "xsportSegue"
    private let workoutSegue = "workoutSegue"
    private let ballSegue = "ballSegue"
    private let musicSegue = "musicSegue"
    private let languageSegue = "languageSegue"
    private let leisureSegue = "leisureSegue"
    private let codingSegue = "codingSegue"
    private let COURSE_ARTICLE_Key = "courseArticle"
    private let photoServlet = "photoServlet"
    private let courseArticleServlet = "CourseArticleServlet"
    
    var timer: Timer?
    var targetIndex = 0
    var hightlightImages = [UIImage]()
    var highlightCourses = [HighlightCourse]()
    var professionCategorys = [ProfessionCategory]()
    
    @IBOutlet weak var masterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Don't Move, Important !!!
        Common.shared.downloadExperience()
        // Important !
        userAccount = UserFile.shared.getUserAccount() // 帳號
        userAccess = UserFile.shared.getUserAccess() // 權限
        userName = UserFile.shared.getUserName() // 名字
        userPortrait = UserFile.shared.loadUserPortrait() // 大頭照

        // Download ProfessionCategorys
        downloadProfessionCategory()
        
        // Download HighlightCoursePhoto
        downloadHighlightCoursePhoto()
        
        // Add gesture recognizer
        let toleft = UISwipeGestureRecognizer(target: self, action: #selector(toLeft))
        toleft.direction = .left
        masterImageView.addGestureRecognizer(toleft)
        
        let toright = UISwipeGestureRecognizer(target: self, action: #selector(toRight))
        toright.direction = .right
        masterImageView.addGestureRecognizer(toright)
        masterImageView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(performSlideShow), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func downloadProfessionCategory() {
        
        let requestGetProfession = [COURSE_ARTICLE_Key:"getProfession"]
        
        Task.postRequestData(urlString: urlString + courseArticleServlet, request: requestGetProfession) { (error, data) in
            
            if let error = error {
                assertionFailure("Fail to get Course from servlet: \(error)." )
                return
            }
            
            guard let data = data, let professionCategorys = try? decoder.decode([ProfessionCategory].self, from: data) else {
                assertionFailure("Invalid data.")
                return
            }
            
            self.professionCategorys = professionCategorys
            
        }
    }
    
    func downloadHighlightCoursePhoto() {
        
        let requestGetCourseNewPhotoId = [COURSE_ARTICLE_Key:"getCourseNewPhotoId"]
        
        // Search HighlightCourse
        Task.postRequestData(urlString: urlString + courseArticleServlet, request: requestGetCourseNewPhotoId) { (error, data) in
            
            if let error = error {
                assertionFailure("Fail to getCourseNewPhotoId: \(error)")
                return
            }
            
            guard let data = data, let highlightCourses = try? decoder.decode([HighlightCourse].self, from: data) else {
                assertionFailure("Data is nil.")
                return
            }
            
            self.highlightCourses = highlightCourses
            self.hightlightImages.removeAll()
            
            // Download HighlightCourse Photo
            for i in 0..<highlightCourses.count {
                let requestHighlightCoursePhoto = ["action":"getImage","photo_id":highlightCourses[i].courseImageId,"imageSize":1000] as [String : Any]
                
                Task.postRequestData(urlString: urlString + self.photoServlet, request: requestHighlightCoursePhoto) { (error, data) in
                    
                    if let error = error {
                        assertionFailure("Fail to getCourseNewPhoto: \(error)")
                        return
                    }
                    
                    guard let data = data, let image = UIImage(data: data) else {
                        assertionFailure("Data is nil.")
                        return
                    }
                    
                    self.hightlightImages.append(image)
                    self.configureImageView()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let controller = segue.destination as? MasterTableViewController else {
            assertionFailure("Fail to get controller.")
            return
        }
        
        switch segue.identifier {
        case waterSegue:
            controller.pickerArray = professionCategorys[0].professionItems
            controller.professionCategory = professionCategorys[0].professionCategory
        case xsportSegue:
            controller.pickerArray = professionCategorys[1].professionItems
            controller.professionCategory = professionCategorys[1].professionCategory
        case workoutSegue:
            controller.pickerArray = professionCategorys[2].professionItems
            controller.professionCategory = professionCategorys[2].professionCategory
            
        case ballSegue:
            controller.pickerArray = professionCategorys[3].professionItems
            controller.professionCategory = professionCategorys[3].professionCategory
            
        case musicSegue:
            controller.pickerArray = professionCategorys[4].professionItems
            controller.professionCategory = professionCategorys[4].professionCategory
            
        case languageSegue:
            controller.pickerArray = professionCategorys[5].professionItems
            controller.professionCategory = professionCategorys[5].professionCategory
            
        case leisureSegue:
            controller.pickerArray = professionCategorys[6].professionItems
            controller.professionCategory = professionCategorys[6].professionCategory
            
        case codingSegue:
            controller.pickerArray = professionCategorys[7].professionItems
            controller.professionCategory = professionCategorys[7].professionCategory
            
        default:
            return
            
        }
    }
    
    func configureImageView() {
        masterImageView.image = hightlightImages[targetIndex]
    }
    
    @objc
    func toRight() {
        
        UIView.transition(with: masterImageView, duration: 0.5, options: [.transitionCrossDissolve, .curveEaseIn], animations: {
            
            self.targetIndex -= 1
            if self.targetIndex < 0 {
                self.targetIndex = self.hightlightImages.count - 1
            }
            self.configureImageView()
        }, completion: nil)
        
    }
    
    @objc
    func toLeft() {
        
        UIView.transition(with: masterImageView, duration: 0.5, options: [.transitionCrossDissolve, .curveEaseIn], animations: {
            
            self.targetIndex += 1
            if self.targetIndex >= self.hightlightImages.count {
                self.targetIndex = 0
            }
            self.configureImageView()
        }, completion: nil)
        
    }
    
    @objc
    func performSlideShow() {
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        masterImageView.layer.add(transition, forKey: nil)
        
        self.targetIndex += 1
        if self.targetIndex >= hightlightImages.count {
            self.targetIndex = 0
        }
        configureImageView()
    }
}

