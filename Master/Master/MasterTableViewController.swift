//
//  MasterTableViewController.swift
//  Master
//
//  Created by Che-wei LIU on 2018/7/24.
//  Copyright © 2018 黎峻亦. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    
    @IBOutlet weak var pickerTextField: UITextField!
    
    private let courseCell = "courseCell"
    private let COURSE_ARTICLE_Key = "courseArticle"
    private let photoServlet = "photoServlet"
    private let courseArticleServlet = "CourseArticleServlet"
    
    var courseList = [Course]()
    var pickerArray = [String]()
    var hiddenCell = [IndexPath]()
    var professionCategory: String?
    var photoList = [Int: UIImage]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setpickerView()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        navigationItem.title = professionCategory
        
        // DoneButton to hide PickerView.
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.isTranslucent = true
        let doneButton = UIBarButtonItem(title: "確定", style: .done, target: nil, action: #selector(hidePickerView))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: true)
        pickerTextField.inputAccessoryView = toolbar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let courseCell = tableView.dequeueReusableCell(withIdentifier: self.courseCell, for: indexPath) as! MasterTableViewCell
        
        let course = courseList[indexPath.row]
        let requestNumOfJoin = ["courseArticle":"courseJoin","courseId":"\(course.courseID)"]
        
        Task.postRequestData(urlString: urlString + courseArticleServlet, request: requestNumOfJoin) { (error, data) in
            
            if let error = error {
                assertionFailure("Fail to get requestNumOfJoin : \(error)")
                return
            }
            
            guard let data = data else {
                assertionFailure("Data is nil.")
                return
            }
            
//            guard let courseDeadLine = self.dateFormatter.date(from: course.courseApplyDeadLine), Date() < courseDeadLine else {
//                self.hiddenCell.append(indexPath)
//                return
//            }
            
            if let peopleNumber = String(data: data, encoding: .utf8) {
                courseCell.numberOfJoinedLabel.text = "參加人數: \(peopleNumber)/\(course.coursePeopleNumber)"
            }
            
            
            courseCell.courseNameLabel.text = course.courseName
            courseCell.starTimeLabel.text = "開始日期: \(course.courseDate)"
            courseCell.endTimeLabel.text = "截止日期: \(course.courseApplyDeadLine)"
            courseCell.locationLabel.text = course.courseLocation
        }
        
        return courseCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "singleCourseVC") as! singleCourseViewController
        nextVC.course = courseList[indexPath.row]
        nextVC.image = photoList[indexPath.row]
        
        let navigation = UINavigationController(rootViewController: nextVC)
        present(navigation, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 120.0
        for indexpath in hiddenCell {
            if indexpath == indexPath {
                height = 0.0
            }
        }
        return CGFloat(height)
    }
    
    private func downloadCourse(professionItem: String) {
        let requestGetCourse = ["courseArticle":"getCourseByProfessionItem","professionItem":professionItem]
        
        Task.postRequestData(urlString: urlString + courseArticleServlet, request: requestGetCourse) { (error, data) in
            
            if let error = error {
                assertionFailure("Fail to get Course from servlet: \(error)." )
                return
            }
            
            guard let data = data, let courseList = try? decoder.decode([Course].self, from: data) else {
                print("Data is nil.")
                return
            }
            
            self.courseList = courseList
            self.handleImage()
        }
    }
    
    private func handleImage(){
        for i in 0..<self.courseList.count {
            self.downloadImages(imageID: courseList[i].courseImageID,
                                doneHandler: { (error, data) in
                if let error = error {
                    assertionFailure("Fail to downloadImage: \(error)")
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    assertionFailure("Data is nil.")
                    return
                }
                self.photoList[i] = image
            })
        }
        self.tableView.reloadData()
    }
    
    private func downloadImages(imageID : Int, doneHandler: @escaping Task.DoneHandler){
        
        let urlStr = urlString + photoServlet
        let request : [String : Any] = ["action":"getImage","photo_id":imageID,"imageSize":1000]
        
        Task.postRequestData(urlString: urlStr, request: request) { (error, data) in
            
            if let error = error{
                assertionFailure("Error : \(error)")
                DispatchQueue.main.async {
                    doneHandler(error,nil)
                }
                return
            }
            guard let data = data else {
                assertionFailure("Invalid data")
                let error = NSError(domain: "Invalid data", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    doneHandler(error,nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                doneHandler(nil,data)
            }
        }
    }
    
}

extension MasterTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private func setpickerView() {
        // Setting pickerView.
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
        pickerTextField.placeholder = professionCategory
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerTextField.text = pickerArray[0] 
        downloadCourse(professionItem: pickerArray[0])
    }
    
    // MARK: PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerArray[row]
        courseList.removeAll()
        photoList.removeAll()
        hiddenCell.removeAll()
        downloadCourse(professionItem: pickerArray[row])
    }
    
    @objc
    func hidePickerView() {
        self.view.endEditing(true)
    }
}

