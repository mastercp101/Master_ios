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
    private let courseArticleServlet = "CourseArticleServlet"
    private let photoServlet = "photoServlet"

    var courseList = [Course]()
    var photoList = [UIImage]()
    var pickerArray = [String]()
    var professionCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = professionCategory
        setpickerView()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: courseCell, for: indexPath) as? MasterTableViewCell else {
            assertionFailure("Fail to get MasterTableViewCell.")
            return UITableViewCell()
        }
        
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

            if let peopleNumber = String(data: data, encoding: .utf8) {
                cell.numberOfJoinedLabel.text = "參加人數: \(peopleNumber)/\(course.coursePeopleNumber)"
            }
            
            cell.courseNameLabel.text = course.courseName
            cell.starTimeLabel.text = "開始日期: \(course.courseDate)"
            cell.endTimeLabel.text = "截止日期: \(course.courseApplyDeadLine)"
            cell.locationLabel.text = course.courseLocation
        }
        
        if course.courseStatusID == 2 {
            cell.isUserInteractionEnabled = false
            cell.subviews.first?.backgroundColor = .gray
            cell.subviews.first?.subviews.first?.backgroundColor = .gray
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let nextVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "singleCourseVC") as? singleCourseViewController else {
            assertionFailure("Fail to get singleCourseVC.")
            return
        }
        
        nextVC.course = courseList[indexPath.row]
        nextVC.image = photoList[indexPath.row]
        
        show(nextVC, sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
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
            self.tableView.reloadData()
            
            var images = [UIImage]()
            for course in courseList {
                self.downloadImages(imageID: course.courseImageID, doneHandler: { (error, data) in
                    
                    if let error = error {
                        assertionFailure("Fail to downloadImage: \(error)")
                        return
                    }
                    
                    guard let data = data, let image = UIImage(data: data) else {
                        assertionFailure("Data is nil.")
                        return
                    }
                    
                    images.append(image)
                    // Check is already download all images.
                    if images.count == courseList.count {
                        self.photoList = images
                    }
                })
            }
            
        }
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
        downloadCourse(professionItem: pickerArray[row])
    }
    
    @objc
    func hidePickerView() {
        self.view.endEditing(true)
    }
}

