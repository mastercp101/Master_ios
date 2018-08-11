//
//  editCourseViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit
import AVFoundation

class editCourseViewController: UIViewController{

    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet var courseTextField: [UITextField]!
    
    let courseCategoryPicker = UIPickerView()
    let datePickerView = UIDatePicker()
    let picker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 12/9)
    
    var image : UIImage?
    
    var professions = [Profession]()
    var course : Course?
    var newCourseDetail : CourseDetail?
    var newCourseProfile : CourseProfile?
    
    
    var whichIsEditing : DateIsEditing?
    var editingStyle : EditingStyle?
    
    var courseName : String?
    var courseCategory : Int?
    var courseDetail : String?
    var courseDate : String?
    var coursePrice : Int?
    var courseLocation : String?
    var courseNeed : String?
    var courseNumberOfPeople : Int?
    var courseQualification : String?
    var courseRegisterDeadline : String?
    var courseNote : String?
    var courseImageID : Int?
    var courseCategoryID = 0
    var updateCourseProfileResult : Int?
    var dateCourse : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增/管理課程"
        encoder.outputFormatting = .init()
        
        // Setting UI or delegate
        setTextView(textView: detailTextView)
        setTextView(textView: noteTextView)
        setGesture()
        cropper.delegate = self
        courseCategoryPicker.delegate = self
        setPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.shared.addObserves(scrollView: scrollView)
        // Download user profession
        downloadUserProfession()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dateCourse = nil
        Common.shared.removeObservers(viewController: self)
    }
    
    private func checkIsSignIn(){
        if userAccount == nil{
            Common.shared.alertUserToLogin(viewController: self)
            return
        }
    }
    
    private func setGesture(){
        addImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(addImageTapped))
        addImageView.addGestureRecognizer(imageGesture)
        
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        containView.addGestureRecognizer(viewGesture)
    }
    
    private func setPicker(){
        datePickerView.datePickerMode = .date
        courseTextField[1].inputView = courseCategoryPicker
        courseTextField[2].inputView = datePickerView
        courseTextField[8].inputView = datePickerView
    }
    
    @IBAction func courseDateEditing(_ sender: UITextField) {
        whichIsEditing = DateIsEditing.courseDate
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @IBAction func courseRegistedEditing(_ sender: UITextField) {
        whichIsEditing = DateIsEditing.courseDeadline
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc
    private func datePickerValueChanged(sender : UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if whichIsEditing == DateIsEditing.courseDate{
            self.dateCourse = sender.date
            sender.minimumDate = Date()
            courseTextField[2].text = dateFormatter.string(from: sender.date)
        }else{
            sender.maximumDate = self.dateCourse!
            courseTextField[8].text = dateFormatter.string(from: sender.date)
        }
    }
    
    @objc
    private func closeKeyboard(){
        view.endEditing(true)
    }
    
    @objc
    private func addImageTapped(){
        cropper.picker = picker
        cropper.cropButtonText = "Crop"
        cropper.cancelButtonText = "Retake"
        
        // Show alert ask user pick picture by camera or photo library.
        Alert.shared.buildPhotoAlert(viewController: self ,takePic: { (camera) in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }) { (photoLibrary) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    
    private func downloadUserProfession(){
        let urlStr = urlString + "UserInfo"
        let request : [String : Any] = ["action":"findProfessionById","user_id": userAccount!]
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
                let encodedProfession = try decoder.decode([Profession].self, from: data)
                self.professions = encodedProfession
                guard encodedProfession.count > 0 else{
                    Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "您還沒新增專業技能") { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                self.courseCategoryPicker.reloadAllComponents()
            }catch{
                assertionFailure("Error : \(error)")
            }
            self.checkEditingStyle()
            self.courseTextField[1].text = self.professions[0].professionName
        }
    }
    
    private func checkEditingStyle(){
        guard self.course != nil else{
            editingStyle = .insertCourse
            return
        }
        editingStyle = .updateCourse
        setCourseInfoToView()
    }
    
    private func setCourseInfoToView(){
        guard let course = course else{
            assertionFailure("Invalid Course")
            return
        }
        
        let professionIndex = professions.index { (profession) -> Bool in
            print("\(profession.professionID),\(course.professionID)")
            guard profession.professionID == course.professionID else{
                return false
            }
            return true
        }
        
        addImageView.image = self.image
        courseTextField[0].text = course.courseName
        detailTextView.text = course.courseContent
        courseTextField[1].text = professions[professionIndex!].professionName
        courseTextField[2].text = course.courseDate
        courseTextField[3].text = String(course.coursePrice)
        courseTextField[4].text = course.courseLocation
        courseTextField[5].text = course.courseNeed
        courseTextField[6].text = String(course.coursePeopleNumber)
        courseTextField[7].text = course.courseQualification
        courseTextField[8].text = course.courseApplyDeadLine
        noteTextView.text = course.courseNote
    }
    
    
    // MARK: - Update Course
    @IBAction func sendBtnTapped(_ sender: Any) {
        guard checkIsTextFieldEmpty() == true && checkIsTextViewEmpty() == true else{
            return
        }
        guard let image = addImageView.image,let base64Image = image.base64() else{
            assertionFailure("Invalid Image")
            return
        }
        
        if editingStyle == EditingStyle.insertCourse{
            let request : [String : Any] = ["action" : "insert","user_id": userAccount!,"photo":base64Image]
            updateImage(request: request)
        }else{ // editingStyle == updateCourse
            let request : [String : Any] = ["action" : "update","photo_id":course!.courseImageID,"photo":base64Image]
            updateImage(request: request)
        }
    }
    
    private func updateImage(request : [String : Any]){
        Task.postRequestData(urlString: "\(urlString)photoServlet", request: request) { (error, data) in
            if let error = error {
                print("Download Data Fail : \(error)")
                return
            }
            guard let data = data,let decodeString = String(data: data, encoding: .utf8) else{
                assertionFailure("Invalid data")
                return
            }
            guard let imageID = Int(decodeString) ,imageID > 0 else{
                assertionFailure("imageID is nil")
                return
            }
            self.courseImageID = imageID
            self.handleTextFieldValue()
            self.createCourse()
        }
    }
    
    private func handleTextFieldValue(){
        
        let professionIndex = self.professions.index { (profession) -> Bool in
            guard profession.professionName == courseTextField[1].text! else{
                return false
            }
            return true
        }
        
        courseName = courseTextField[0].text!
        courseCategory  = self.professions[professionIndex!].professionID
        courseDetail = detailTextView.text!
        courseDate = courseTextField[2].text!
        coursePrice = Int(courseTextField[3].text!)
        courseLocation = courseTextField[4].text!
        courseNeed = courseTextField[5].text!
        courseNumberOfPeople = Int(courseTextField[6].text!)
        courseQualification = courseTextField[7].text!
        courseRegisterDeadline = courseTextField[8].text!
        courseNote = noteTextView.text!
        
    }
    
    private func createCourse(){
        newCourseDetail = CourseDetail(courseCategoryID: course?.courseCategoryID ?? self.courseCategoryID,
                                       professionID: courseCategory!,
                                       courseName: courseName! ,
                                       courseContent: courseDetail!,
                                       coursePrice: coursePrice!,
                                       courseNeed : courseNeed!,
                                       courseQualification: courseQualification!,
                                       courseLocation: courseLocation!,
                                       courseNote: courseNote!)
        
        // finish create course, call update course detail method
        if editingStyle == EditingStyle.insertCourse{
            updateCourseDetail(action: "insert")
        }else{
            updateCourseDetail(action: "update")
        }
    }
    
    private func updateCourseDetail(action : String){
        
        guard let encodedCourseDetail = try? encoder.encode(newCourseDetail),
            let courseDetailStr = String(data: encodedCourseDetail, encoding: .utf8) else{
                assertionFailure("Encode Data Fail")
                return
        }
        
        let request : [String : Any] = ["action":action,"course":courseDetailStr]
        Task.postRequestData(urlString: urlString + "CourseDetailServlet", request: request) { (error, data) in
            if let error = error{
                print("Download Data Fail : \(error)")
                return
            }
            guard let data = data ,let decodeString = String(data: data, encoding: .utf8) else{
                assertionFailure("Invalid data")
                return
            }
            guard let courseCategoryID = Int(decodeString), courseCategoryID > 0 else{
                assertionFailure("Update CourseDetail fail")
                return
            }
            self.courseCategoryID = courseCategoryID
            self.createCourseProfile()
            
            if self.editingStyle == EditingStyle.insertCourse{
                self.updateCourseProfile(action: "insert")
            }else{
                self.updateCourseProfile(action: "update")
            }
        }
    }
    
    private func createCourseProfile(){
        newCourseProfile = CourseProfile(courseID: course?.courseID ?? 0,
                                         userID: userAccount!,
                                         courseDate: courseDate!,
                                         courseApplyDeadLine: courseRegisterDeadline!,
                                         coursePeopleNumber: courseNumberOfPeople!,
                                         courseImageID: course?.courseImageID ?? self.courseImageID!,
                                         courseStatusID: 1,
                                         courseCategoryID: course?.courseCategoryID ?? self.courseCategoryID)
    }
    
    private func updateCourseProfile(action : String){
        guard let encodedCourseProfile = try? encoder.encode(newCourseProfile),
            let courseProfileStr = String(data: encodedCourseProfile, encoding: .utf8)else{
                assertionFailure("Encode Data Fail")
                return
        }
        let request = ["action":action,"course":courseProfileStr]
        Task.postRequestData(urlString: urlString + "CourseServlet", request: request) { (error, data) in
            if let error = error{
                print("Download Data Fail : \(error)")
                return
            }
            guard let data = data ,let decodeString = String(data: data, encoding: .utf8) else{
                assertionFailure("Invalid data")
                return
            }
            guard let updateCourseProfileResult = Int(decodeString) ,updateCourseProfileResult > 0 else{
                assertionFailure("Update CourseProfile Fail")
                return
            }
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "上傳課程成功！") { (_) in
                self.performSegue(withIdentifier: "unwindToCourseWithEditCourseSuccess", sender: nil)
            }
        }
    }
    
    private func checkIsTextViewEmpty() -> Bool{
        if detailTextView.text == ""{
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "課程內容不能為空白"){_ in }
            return false
        }else if noteTextView.text == ""{
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "課程提醒不能為空白"){_ in }
            return false
        }
        return true
    }
    
    private func checkIsTextFieldEmpty() -> Bool{
        for textField in courseTextField{
            let text = textField.text!.trimmingCharacters(in: .whitespaces)
            let alertTitle = textField.restorationIdentifier!
            guard text != "" else{
                Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "\(alertTitle)不能為空白") { (_) in}
                return false
            }
        }
        return true
    }
}

extension editCourseViewController : UIImageCropperProtocol{
    private func setTextView(textView : UITextView){
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.backgroundColor = UIColor.white
    }
    
    // MARK: - Did Finish Crop Image
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        
        guard let image = croppedImage else{
            assertionFailure("Invalid Image")
            return
        }
        // Check if image is too large. If image too large then resize it.
        let height = image.size.height
        let width = image.size.width
        
        guard height * width > 900 * 1200 else{
            addImageView.image = image
            return
        }
        
        // Start resize image
        let size = __CGSizeApplyAffineTransform((croppedImage?.size)!, CGAffineTransform(scaleX: 0.5, y: 0.5))
        let hasAlpha = false
        let scale : CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else{
            assertionFailure("Scale Image Fail")
            return
        }
        UIGraphicsEndImageContext()
        addImageView.image = scaledImage
    }
}

extension editCourseViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return professions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return professions[row].professionName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.courseTextField[1].text = professions[row].professionName
    }
}

enum EditingStyle{
    case insertCourse
    case updateCourse
}

enum DateIsEditing{
    case courseDate
    case courseDeadline
}












