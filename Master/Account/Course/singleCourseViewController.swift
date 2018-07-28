//
//  singleCourseViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class singleCourseViewController: UIViewController {
    
    @IBOutlet weak var singleCourseTableView: UITableView!
    var course : Course?
    var image : UIImage?
    var applyList = [FindByCourseApply]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        singleCourseTableView.setCellAutoRowHeight()
    }
    
    @IBAction func manageBtnTapped(_ sender: Any) {
        
        guard let course = course else{
            assertionFailure("Invalid Course")
            return
        }
        downloadApply(courseID: course.courseID)
    }
    
    private func downloadApply(courseID : Int){
        let urlStr = urlString + "applyServlet"
        let request : [String : Any] = ["action":"findByCourseId","course_id":courseID]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error {
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data else{
                assertionFailure("Invalid Data")
                return
            }
            
            do{
                let applyList = try decoder.decode([FindByCourseApply].self, from: data)
                self.applyList = applyList
                self.showManageAlert()
            }catch{
                assertionFailure("Error : \(error)")
            }
        }
    }
    
    private func showManageAlert(){
        Alert.shared.buildTripleAlert(viewController: self,
                                      alertTitla: nil,
                                      actionTitles: ["管理學生","管理課程","刪除課程"],
                                      useCancelAction: true,
                                      firstAction:{ (firstAction) in
            // Manage Student
            self.presentManageStudentVC()
                                        
        }, secondAction: { (secondAction) in
            
            // Manage Course
            self.presentEditCourseVC()
            
        }) { (thirdAction) in
            Alert.shared.buildDoubleAlert(viewController: self,
                                          alertTitle: "確定要刪除這個課程？",
                                          alertMessage: nil,
                                          actionTitles: ["確定","取消"],
                                          firstHandler: { (firstAction) in
            // handle Delete Course
            self.handleDeleteCourse()
                                            
            }, secondHandler: { _ in})
        }
    }
    
    private func handleDeleteCourse(){
        if applyList.count > 0{
            deleteApply()
        }else{
            deleteCourse()
        }
    }
    
    private func deleteApply(){
        guard let course = course else{
            return
        }
        let urlStr = urlString + "applyServlet"
        let request : [String : Any] = ["action":"deleteByCourseId","course_id":course.courseID]
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            if let error = error{
                assertionFailure("Error : \(error)")
                return
            }
            guard let data = data ,let resultStr = String(data: data, encoding: .utf8),let result = Int(resultStr) else{
                assertionFailure("Invalid data")
                return
            }
            if result > 0{
                // delete course
                self.deleteCourse()
            }else{
                self.deleteCourseFailAlert()
            }
        }
    }
    private func deleteCourseFailAlert(){
        Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "刪除課程失敗") { (action) in}
    }
    
    // Delete Course
    private func deleteCourse(){
        
        guard let course = course ,
            let encodedCourse = try? encoder.encode(course),
            let encodedCourseStr = String(data: encodedCourse, encoding: .utf8) else{
            assertionFailure("Invalid Course")
            return
        }
        
        let urlStr = urlString + "finalCourseServlet"
        let request : [String : Any] = ["action":"delete","course":encodedCourseStr]
        Task.postRequestData(urlString: urlStr, request: request, doneHandler: { (error, data) in
            if let error = error{
                assertionFailure("Error : \(error)")
                return
            }
            
            guard let data = data ,let resultStr = String(data: data, encoding: .utf8),let result = Int(resultStr) else{
                assertionFailure("Delete Course Fail")
                return
            }
            
            if result > 0{
                self.performSegue(withIdentifier: "unwindToCourseWithDeleteCourse", sender: self)
            }else{
                self.deleteCourseFailAlert()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCourseWithDeleteCourse"{
            let nextVC =  segue.destination as! CourseViewController
            nextVC.isCourseDelete = true
        }else{
            let nextVC =  segue.destination as! CourseViewController
            nextVC.isCourseDelete = false
        }
    }
    
    private func presentManageStudentVC(){
        let nextVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "manageStudentVC") as? manageStudentViewController
        guard let course = self.course else{
            assertionFailure("Invalid Course")
            return
        }
        nextVC?.applyList = self.applyList
        nextVC?.courseID = course.courseID
        let navigation = UINavigationController(rootViewController: nextVC!)
        self.present(navigation, animated: true, completion: nil)
    }
    
    private func presentEditCourseVC(){
        let nextVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "editCourseVC") as! editCourseViewController
        nextVC.course = self.course
        nextVC.image = self.image
        let navigation = UINavigationController(rootViewController: nextVC)
        self.present(navigation, animated: true, completion: nil)
    }
}

extension singleCourseViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            return buildFirstCell(tableView: tableView, indexPath: indexPath)!
        }else{
            return buildOtherCell(tableView: tableView, indexPath: indexPath)!
        }
    }
    
    private func buildFirstCell(tableView : UITableView,indexPath : IndexPath) -> UITableViewCell?{
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! courseMainCell
        guard let image = image else{
            assertionFailure("Invalid Image")
            return nil
        }
        guard let course = course else{
            assertionFailure("Invalid Course")
            return nil
        }
        cell.mainImageView.image = image
        cell.courseNameLabel.text = course.courseName
        cell.courseDateLabel.text = course.courseDate
        cell.coursePriceLabel.text = String(course.coursePrice)
        cell.selectionStyle = .none
        cell.applyBtn.setBorder()
        cell.contectBtn.setBorder()
        return cell
    }
    
    private func buildOtherCell(tableView : UITableView,indexPath : IndexPath) -> UITableViewCell?{
        guard let course = course else{
            assertionFailure("Invalid Course")
            return nil
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! courseInfoCell
        var title = ""
        var content = ""
        switch indexPath.row{
        case 1 :
            title = "內容"
            content = course.courseContent
            break
        case 2 :
            title = "地點"
            content = course.courseLocation
            break
        case 3 :
            title = "課程需求"
            content = course.courseNeed
            break
        case 4 :
            title = "招生人數"
            content = String(course.coursePeopleNumber)
            break
        case 5 :
            title = "參加資格"
            content = course.courseQualification
            break
        case 6 :
            title = "注意事項"
            content = course.courseNote
            break
        default:
            break
        }
        cell.courseInfoTitle.text = title
        cell.courseInfoContent.text = content
        return cell
    }
}
