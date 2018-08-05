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
    var courseList = [Course]()
    var photoList = [Photo]()
    var isCourseDelete : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setICarousel()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if isCourseDelete == true{
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "課程刪除成功") { (action) in}
        }
        identifyAccess()
    }
    override func viewDidDisappear(_ animated: Bool) {
        // in case of course list have changed
        courseList = [Course]()
        photoList = [Photo]()
    }
    
    
    
    private func identifyAccess(){
        if userAccess == .coach{
            // download coach owned course
            downloadCourse(action: "findCourseByCoach")
        }else if userAccess == .student{
            // download student owned course
            downloadCourse(action: "findCourseByStudent")
        }else{
            // show alert to user warn that didn't sign in
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "您還未登入") { (alert) in
                let nextVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
                self.present(nextVC, animated: true, completion: nil)
            }
            return
        }
    }
    
    private func downloadCourse(action : String){
        // Download Course
        let urlStr = urlString + "finalCourseServlet"
        let request = ["action" : action]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error{
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data else{
                assertionFailure("Invalid data")
                return
            }
            do{
                let decodedCourseList = try decoder.decode([Course].self, from: data)
                self.courseList = decodedCourseList
                // Download Image
                for course in decodedCourseList{
                    self.downloadImage(imageID: course.courseImageID)
                }
            }catch{
                assertionFailure("Decode Course Fail : \(error)")
            }
        }
    }
    
    private func downloadImage(imageID : Int){
        let urlStr = urlString + "photoServlet"
        let request : [String : Any] = ["action":"getImage","photo_id":imageID,"imageSize":1000]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error{
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data ,let image = UIImage(data: data)else{
                assertionFailure("Invalid data")
               return
            }
            let newPhoto = Photo(imageID: imageID, image: image)
            self.photoList.append(newPhoto)
            
            // if finish download last image reload iCarousel View.
            if self.photoList.count == self.courseList.count{
                self.iCarouselView.reloadData()
            }
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        DispatchQueue.main.async {
            let nextVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "editCourseVC") as! editCourseViewController
            let navigation = UINavigationController(rootViewController: nextVC)
            self.present(navigation, animated: true, completion: nil)
        }
    }
    @IBAction func unwindToCourse(_ segue : UIStoryboardSegue){}
}


// MARK: - iCarousel Setting
extension CourseViewController : iCarouselDelegate,iCarouselDataSource{
    
    private func setICarousel(){
        iCarouselView.type = .rotary
        iCarouselView.contentMode = .scaleAspectFit
        iCarouselView.isPagingEnabled = true
        iCarouselView.isVertical = true
    }
    
    private func findImage(index : Int) -> UIImage?{
        
        if let photoListIndex = photoList.index(where: { (photo) -> Bool in
            photo.imageID == self.courseList[index].courseImageID
        }) {
            return self.photoList[photoListIndex].image
        }
        return nil
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.courseList.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var courseItemView : CourseItemView
        
        if view == nil{
            let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
            courseItemView = CourseItemView(frame: frame)
            courseItemView.courseImageView.contentMode = .scaleAspectFit
        }else{
            courseItemView = view as! CourseItemView
        }
        
        if let image = findImage(index: index) {
            courseItemView.courseImageView.image = image
        }
        
        courseItemView.courseNameLabel.text = self.courseList[index].courseName
        courseItemView.courseDateLabel.text = self.courseList[index].courseDate
        if self.courseList[index].courseStatusID == 1{
            courseItemView.courseStatusLabel.text = "報名中"
        }else{
            courseItemView.courseStatusLabel.text = "報名截止"
        }
        return courseItemView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let nextVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "singleCourseVC") as! singleCourseViewController
        nextVC.course = self.courseList[index]
        nextVC.title = nextVC.course?.courseName
        if let image = findImage(index: index) {
            nextVC.image = image
        }
        let navigation = UINavigationController(rootViewController: nextVC)
        self.present(navigation, animated: true, completion: nil)
    }
}
