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
    private let courseArticleServlet = "/CourseArticleServlet"
    
    var targerIndex = -1
    var imageList = [String]()
    var professionCategorys = [ProfessionCategory]()
    
    @IBOutlet weak var masterImgeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Important !
        userAccount = UserFile.shared.getUserAccount() // 帳號
        userAccess = UserFile.shared.getUserAccess() // 權限
        
        // Download ProfessionCategorys
//        downloadProfessionCategory()
        
        // Add gesture recognizer
        
    }
    
    func downloadProfessionCategory() {
        
        let requestGetProfession = ["courseArticle":"getProfession"]
        
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
        
        
    }
    
    func toRight() {
        
        UIView.transition(with: masterImgeView, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
            
            self.targerIndex -= 1
            if self.targerIndex < 0 {
                self.targerIndex = self.imageList.count - 1
            }
            self.configureImageView()
        }, completion: nil)
        
    }
    
    func toLeft() {
        
        UIView.transition(with: masterImgeView, duration: 0.5, options: [.transitionFlipFromRight], animations: {
            
            self.targerIndex += 1
            if self.targerIndex >= self.imageList.count {
                self.targerIndex = 0
            }
            self.configureImageView()
        }, completion: nil)
        
    }
}

