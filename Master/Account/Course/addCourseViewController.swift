//
//  addCourseViewController.swift
//  Master
//
//  Created by 黎峻亦 on 2018/7/15.
//  Copyright © 2018年 黎峻亦. All rights reserved.
//

import UIKit

class addCourseViewController: UIViewController{

    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet var courseTextField: [UITextField]!
    
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
    
    var whichIsEditing : dateIsEditing?
    let datePickerView = UIDatePicker()
    
    
    let picker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 16/9)
    
    var newCourseDetail : CourseDetail?
    var newCourseProfile : CourseProfile?
    
    var courseImageID : Int?
    var courseCategoryID : Int?
    var updateCourseProfileResult : Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        encoder.outputFormatting = .init()
        setTextView(textView: detailTextView)
        setTextView(textView: noteTextView)
        
        addImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(addImageTapped))
        addImageView.addGestureRecognizer(imageGesture)
        
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        containView.addGestureRecognizer(viewGesture)
        
        cropper.delegate = self
        setDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.shared.addObserves(scrollView: scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Common.shared.removeObservers(viewController: self)
    }
    
    private func setDatePicker(){
        datePickerView.datePickerMode = .date
        courseTextField[2].inputView = datePickerView
        courseTextField[8].inputView = datePickerView
    }
    
    @IBAction func courseDateEditing(_ sender: UITextField) {
        whichIsEditing = dateIsEditing.courseDate
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @IBAction func courseRegistedEditing(_ sender: UITextField) {
        whichIsEditing = dateIsEditing.courseDeadline
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    
    @objc
    private func datePickerValueChanged(sender : UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if whichIsEditing == dateIsEditing.courseDate{
            courseTextField[2].text = dateFormatter.string(from: sender.date)
        }else{
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
        Alert.shared.buildPhotoAlert(viewController: self ,takePic: { (camera) in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }) { (photoLibrary) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Update Course
    @IBAction func sendBtnTapped(_ sender: Any) {
        guard checkIsTextFieldEmpty() == true && checkIsTextViewEmpty() == true else{
            return
        }
        
        updateImage()
        
    }
    
    private func updateImage(){
        guard let image = addImageView.image,let base64Image = image.base64() else{
            assertionFailure("Invalid Image")
            return
        }
        let request = ["action" : "insert","user_id":"billy","photo":base64Image]
        
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        courseName = courseTextField[0].text!
        print(courseName!)
        courseCategory  = Int(courseTextField[1].text!)
        courseDetail = detailTextView.text!
//        courseDate = dateFormatter.date(from: courseTextField[2].text!)!
        courseDate = courseTextField[2].text!
        coursePrice = Int(courseTextField[3].text!)
        courseLocation = courseTextField[4].text!
        courseNeed = courseTextField[5].text!
        courseNumberOfPeople = Int(courseTextField[6].text!)
        courseQualification = courseTextField[7].text!
//        courseRegisterDeadline = dateFormatter.date(from: courseTextField[8].text!)!
        courseRegisterDeadline = courseTextField[8].text!
        courseNote = noteTextView.text!
        
        print(courseDate!)
        print(courseRegisterDeadline!)
    }
    
    private func createCourse(){
        newCourseDetail = CourseDetail(courseCategoryID: 0,
                                       professionID: courseCategory!,
                                       courseName: courseName! ,
                                       courseContent: courseDetail!,
                                       coursePrice: coursePrice!,
                                       courseNeed : courseNeed!,
                                       courseQualification: courseQualification!,
                                       courseLocation: courseLocation!,
                                       courseNote: courseNote!)
        
        updateCourseDetail()
    }
    private func createCourseProfile(courseCategoryID : Int){
        newCourseProfile = CourseProfile(courseID: 0,
                                         userID: "billy",
                                         courseDate: courseDate!,
                                         courseApplyDeadLine: courseRegisterDeadline!,
                                         coursePeopleNumber: courseNumberOfPeople!,
                                         courseImageID: self.courseImageID!,
                                         courseStatusID: 1,
                                         courseCategoryID: courseCategoryID)
    }
    
    private func updateCourseDetail(){
        guard let encodedCourseDetail = try? encoder.encode(newCourseDetail),
            let courseDetailStr = String(data: encodedCourseDetail, encoding: .utf8) else{
                assertionFailure("Encode Data Fail")
            return
        }
        let request = ["action":"insert","course":courseDetailStr]
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
            self.createCourseProfile(courseCategoryID: courseCategoryID)
            self.updateCourseProfile()
        }
    }
    
    private func updateCourseProfile(){
        guard let encodedCourseProfile = try? encoder.encode(newCourseProfile),
            let courseProfileStr = String(data: encodedCourseProfile, encoding: .utf8)else{
                assertionFailure("Encode Data Fail")
                return
        }
        let request = ["action":"insert","course":courseProfileStr]
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
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "新增課程成功！") { (_) in
                self.dismiss(animated: true, completion: nil)
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
            guard textField.text == "" else{
                return true
            }
            Alert.shared.buildSingleAlert(viewConteoller: self, alertTitle: "\(textFieldTitle(textField: textField))不能為空白") { (_) in}
            return false
        }
        return true
    }
    
    private func textFieldTitle(textField : UITextField) -> String{
        switch textField.tag{
        case 0:
            return "課程名稱"
        case 1:
            return "課程類別"
        case 2:
            return "課程日期"
        case 3:
            return "課程價格"
        case 4:
            return "課程地點"
        case 5:
            return "課程要求"
        case 6:
            return "課程人數"
        case 7:
            return "報名資格"
        case 8:
            return "報名期限"
        default:
            return ""
        }
    }
}

enum dateIsEditing{
    case courseDate
    case courseDeadline
}

extension addCourseViewController : UIImageCropperProtocol{
    private func setTextView(textView : UITextView){
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.backgroundColor = UIColor.white
    }
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        addImageView.contentMode = .scaleAspectFit
        addImageView.clipsToBounds = true
        addImageView.image = croppedImage
    }
}

